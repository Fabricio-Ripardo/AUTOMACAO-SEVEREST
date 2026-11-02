# Automação de testes da API ServeRest

![Testes](https://github.com/Fabricio-Ripardo/AUTOMACAO-SEVEREST/actions/workflows/testes.yml/badge.svg)

Testes automatizados da [ServeRest](https://serverest.dev), uma API REST que simula uma loja virtual, usando **Robot Framework** e **RequestsLibrary**.

## O que é testado

| Rota | Cenários positivos | Cenários negativos |
| --- | --- | --- |
| `/usuarios` | cadastro, listagem, filtro por e-mail, busca por ID, edição e exclusão | e-mail duplicado, e-mail vazio, ID inexistente, exclusão sem registro |
| `/login` | login com credenciais válidas e retorno do token `Bearer` | senha incorreta, e-mail não cadastrado, campos vazios |
| `/produtos` | cadastro, listagem, busca por ID, edição e exclusão | nome repetido, sem token (401), usuário sem permissão de admin (403), ID inexistente |
| `/carrinhos` | cadastro, concluir compra e cancelar compra com conferência do estoque | mais de um carrinho por usuário, sem token, estoque insuficiente |

Ao todo são **30 casos de teste**, marcados com as tags `positivo`, `negativo` e `seguranca`.

## Como os testes foram pensados

- **Independentes:** cada teste cria os próprios dados (usuários com e-mail aleatório, produtos com nome aleatório). Não há IDs fixos, então os testes passam em qualquer execução, mesmo depois que a ServeRest reinicia a base.
- **Validações de verdade:** cada teste confere o status code e, quando faz sentido, a mensagem da API e os campos da resposta. Depois de editar ou excluir, o teste consulta o registro de novo para garantir que a alteração aconteceu.
- **Regras de negócio:** os testes de carrinho conferem se o estoque do produto diminui ao comprar e volta ao valor original ao cancelar a compra.
- **Keywords reutilizáveis:** a lógica das requisições fica em `resources/`, e os testes em `tests/` leem quase como uma especificação.

## Estrutura

```
resources/
  base.resource         configuração, geração de dados e validações comuns
  usuarios.resource     keywords da rota /usuarios
  login.resource        keywords de login e obtenção de token
  produtos.resource     keywords da rota /produtos
  carrinhos.resource    keywords da rota /carrinhos
tests/
  usuarios.robot
  login.robot
  produtos.robot
  carrinhos.robot
.github/workflows/
  testes.yml            execução automática no GitHub Actions
```

## Como rodar

Pré-requisito: Python 3.10+.

```bash
pip install -r requirements.txt
robot --outputdir reports tests
```

Abra `reports/report.html` no navegador para ver o relatório.

Rodar só uma parte:

```bash
robot --outputdir reports tests/login.robot        # um arquivo
robot --outputdir reports --include negativo tests # só os cenários negativos
```

## Integração contínua

Os testes rodam automaticamente no **GitHub Actions** a cada push, em pull requests e toda segunda-feira. O relatório de cada execução fica disponível para download na aba **Actions** do repositório.

## Autor

**Fabricio Ripardo** — [LinkedIn](https://www.linkedin.com/in/fabricio-ripardo-688082265) · [GitHub](https://github.com/Fabricio-Ripardo)
