# Automação de testes da ServeRest — API e Web

![Testes](https://github.com/Fabricio-Ripardo/AUTOMACAO-SEVEREST/actions/workflows/testes.yml/badge.svg)

Testes automatizados da [ServeRest](https://serverest.dev), uma loja virtual simulada, em duas frentes:

- **API** — a [API REST](https://serverest.dev), com **Robot Framework + RequestsLibrary**
- **Web** — o [front-end](https://front.serverest.dev), com **Robot Framework + SeleniumLibrary**

## O que é testado

### API — 30 casos

| Rota | Cenários positivos | Cenários negativos |
| --- | --- | --- |
| `/usuarios` | cadastro, listagem, filtro por e-mail, busca por ID, edição e exclusão | e-mail duplicado, e-mail vazio, ID inexistente, exclusão sem registro |
| `/login` | login válido e retorno do token `Bearer` | senha incorreta, e-mail não cadastrado, campos vazios |
| `/produtos` | cadastro, listagem, busca por ID, edição e exclusão | nome repetido, sem token (401), usuário sem permissão de admin (403), ID inexistente |
| `/carrinhos` | cadastro, concluir e cancelar compra com conferência do estoque | mais de um carrinho por usuário, sem token, estoque insuficiente |

### Web — 14 casos

| Tela | Cenários positivos | Cenários negativos |
| --- | --- | --- |
| Login | administrador vai para a área admin; usuário comum vai para a loja | senha incorreta, e-mail não cadastrado |
| Cadastro de usuários | cadastro de administrador e de usuário comum, conferindo a listagem | e-mail já usado, sem nome, sem e-mail, sem senha |
| Cadastro de produtos | cadastro conferindo a listagem | sem nome, sem preço, sem descrição |

Os testes são marcados com as tags `api`/`web`, `positivo`, `negativo` e `seguranca`.

## Como os testes foram pensados

- **Independentes:** cada teste cria os próprios dados (e-mails e nomes aleatórios). Não há IDs nem usuários fixos, então os testes passam em qualquer execução, mesmo depois que a ServeRest reinicia a base.
- **Dados preparados pela API:** os testes Web criam os usuários de apoio pela API, que é rápida e estável, e usam o navegador só para o que estão testando.
- **Validações de verdade:** status code, mensagens e campos da resposta na API; URL, mensagens de erro e listagens na interface.
- **Regras de negócio:** os testes de carrinho conferem se o estoque diminui ao comprar e volta ao valor original ao cancelar.
- **Sem `Sleep`:** a interface usa esperas explícitas (o teste espera o elemento aparecer), o que deixa a execução mais rápida e estável.
- **Navegador limpo a cada teste**, com screenshot automático no relatório quando um teste falha.

## Estrutura

```
resources/
  api/      keywords das rotas (usuarios, login, produtos, carrinhos)
  web/      keywords e locators de cada tela (login, usuarios, produtos)
tests/
  api/      30 casos de teste da API
  web/      14 casos de teste da interface
.github/workflows/testes.yml   execução automática no GitHub Actions
```

## Como rodar

Pré-requisitos: Python 3.10+ e Google Chrome (para os testes Web).

```bash
pip install -r requirements.txt

robot --outputdir reports tests                    # tudo
robot --outputdir reports tests/api                # só API
robot --outputdir reports tests/web                # só Web
robot --outputdir reports --include negativo tests # só cenários negativos
```

Abra `reports/report.html` no navegador para ver o relatório.

Para rodar os testes Web sem abrir a janela do navegador:

```bash
robot --outputdir reports --variable HEADLESS:True tests/web
```

## Integração contínua

Os testes de API e Web rodam em paralelo no **GitHub Actions** a cada push, em pull requests e toda segunda-feira. O relatório de cada execução fica disponível para download na aba **Actions**.

## Autor

**Fabricio Ripardo** — [LinkedIn](https://www.linkedin.com/in/fabricio-ripardo-688082265) · [GitHub](https://github.com/Fabricio-Ripardo)
