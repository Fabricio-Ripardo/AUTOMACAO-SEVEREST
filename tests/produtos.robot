*** Settings ***
Documentation     Testes da rota /produtos da ServeRest.
Resource          ../resources/login.resource
Resource          ../resources/produtos.resource
Suite Setup       Preparar Tokens
Test Tags         produtos


*** Test Cases ***
Cadastrar produto como administrador
    [Tags]    positivo
    ${nome}=        Gerar Nome Aleatorio    Produto
    ${response}=    Cadastrar Produto    ${TOKEN_ADMIN}    ${nome}
    Status Code Deve Ser    ${response}    201
    Mensagem Deve Ser       ${response}    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    _id

Nao deve cadastrar produto com nome repetido
    [Tags]    negativo
    ${nome}=        Gerar Nome Aleatorio    Produto
    ${primeiro}=    Cadastrar Produto    ${TOKEN_ADMIN}    ${nome}
    Status Code Deve Ser    ${primeiro}    201
    ${response}=    Cadastrar Produto    ${TOKEN_ADMIN}    ${nome}
    Status Code Deve Ser    ${response}    400
    Mensagem Deve Ser       ${response}    Já existe produto com esse nome

Nao deve cadastrar produto sem token
    [Tags]    negativo    seguranca
    ${nome}=        Gerar Nome Aleatorio    Produto
    ${response}=    Cadastrar Produto    ${None}    ${nome}
    Status Code Deve Ser    ${response}    401
    Mensagem Deve Ser       ${response}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Nao deve cadastrar produto com usuario comum
    [Tags]    negativo    seguranca
    ${nome}=        Gerar Nome Aleatorio    Produto
    ${response}=    Cadastrar Produto    ${TOKEN_COMUM}    ${nome}
    Status Code Deve Ser    ${response}    403
    Mensagem Deve Ser       ${response}    Rota exclusiva para administradores

Listar produtos
    [Tags]    positivo
    ${response}=    Listar Produtos
    Status Code Deve Ser    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    produtos

Buscar produto por ID
    [Tags]    positivo
    ${id}=          Criar Produto Valido    ${TOKEN_ADMIN}
    ${response}=    Buscar Produto Por ID    ${id}
    Status Code Deve Ser    ${response}    200
    Should Be Equal    ${response.json()}[_id]    ${id}

Buscar produto com ID inexistente
    [Tags]    negativo
    ${response}=    Buscar Produto Por ID    idInexistente123
    Status Code Deve Ser    ${response}    400
    Mensagem Deve Ser       ${response}    Produto não encontrado

Editar produto
    [Tags]    positivo
    ${id}=          Criar Produto Valido    ${TOKEN_ADMIN}
    ${novo_nome}=   Gerar Nome Aleatorio    Produto Editado
    ${response}=    Editar Produto    ${TOKEN_ADMIN}    ${id}    ${novo_nome}    250    Descricao atualizada    5
    Status Code Deve Ser    ${response}    200
    Mensagem Deve Ser       ${response}    Registro alterado com sucesso
    ${consulta}=    Buscar Produto Por ID    ${id}
    Should Be Equal                ${consulta.json()}[nome]          ${novo_nome}
    Should Be Equal As Integers    ${consulta.json()}[preco]         250
    Should Be Equal As Integers    ${consulta.json()}[quantidade]    5

Excluir produto
    [Tags]    positivo
    ${id}=          Criar Produto Valido    ${TOKEN_ADMIN}
    ${response}=    Excluir Produto    ${TOKEN_ADMIN}    ${id}
    Status Code Deve Ser    ${response}    200
    Mensagem Deve Ser       ${response}    Registro excluído com sucesso
    ${consulta}=    Buscar Produto Por ID    ${id}
    Status Code Deve Ser    ${consulta}    400


*** Keywords ***
Preparar Tokens
    ${admin}=     Criar Usuario E Obter Token    administrador=true
    ${comum}=     Criar Usuario E Obter Token    administrador=false
    Set Suite Variable    ${TOKEN_ADMIN}     ${admin}
    Set Suite Variable    ${TOKEN_COMUM}     ${comum}
