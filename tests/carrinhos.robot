*** Settings ***
Documentation     Testes da rota /carrinhos da ServeRest (fluxo de compra).
...               Cada teste usa um usuário novo, porque a API só permite um carrinho por usuário.
Resource          ../resources/login.resource
Resource          ../resources/produtos.resource
Resource          ../resources/carrinhos.resource
Suite Setup       Preparar Produto
Test Tags         carrinhos


*** Test Cases ***
Cadastrar carrinho
    [Tags]    positivo
    ${token}=       Criar Usuario E Obter Token
    ${response}=    Cadastrar Carrinho    ${token}    ${ID_PRODUTO}    2
    Status Code Deve Ser    ${response}    201
    Mensagem Deve Ser       ${response}    Cadastro realizado com sucesso
    ${carrinho}=    Buscar Carrinho Por ID    ${response.json()}[_id]
    Status Code Deve Ser           ${carrinho}    200
    Should Be Equal As Integers    ${carrinho.json()}[quantidadeTotal]    2
    [Teardown]    Cancelar Compra    ${token}

Nao deve ter mais de um carrinho por usuario
    [Tags]    negativo
    ${token}=       Criar Usuario E Obter Token
    ${primeiro}=    Cadastrar Carrinho    ${token}    ${ID_PRODUTO}
    Status Code Deve Ser    ${primeiro}    201
    ${response}=    Cadastrar Carrinho    ${token}    ${ID_PRODUTO}
    Status Code Deve Ser    ${response}    400
    Mensagem Deve Ser       ${response}    Não é permitido ter mais de 1 carrinho
    [Teardown]    Cancelar Compra    ${token}

Nao deve cadastrar carrinho sem token
    [Tags]    negativo    seguranca
    ${response}=    Cadastrar Carrinho    ${None}    ${ID_PRODUTO}
    Status Code Deve Ser    ${response}    401

Nao deve cadastrar carrinho com estoque insuficiente
    [Tags]    negativo
    ${token}=       Criar Usuario E Obter Token
    ${response}=    Cadastrar Carrinho    ${token}    ${ID_PRODUTO}    9999
    Status Code Deve Ser    ${response}    400
    Mensagem Deve Ser       ${response}    Produto não possui quantidade suficiente

Concluir compra mantem o estoque reduzido
    [Tags]    positivo
    ${id_produto}=    Criar Produto Valido    ${TOKEN_ADMIN}    quantidade=10
    ${token}=         Criar Usuario E Obter Token
    ${carrinho}=      Cadastrar Carrinho    ${token}    ${id_produto}    3
    Status Code Deve Ser    ${carrinho}    201
    ${response}=      Concluir Compra    ${token}
    Status Code Deve Ser    ${response}    200
    Mensagem Deve Ser       ${response}    Registro excluído com sucesso
    Estoque Do Produto Deve Ser    ${id_produto}    7

Cancelar compra devolve os produtos ao estoque
    [Tags]    positivo
    ${id_produto}=    Criar Produto Valido    ${TOKEN_ADMIN}    quantidade=10
    ${token}=         Criar Usuario E Obter Token
    ${carrinho}=      Cadastrar Carrinho    ${token}    ${id_produto}    3
    Status Code Deve Ser    ${carrinho}    201
    Estoque Do Produto Deve Ser    ${id_produto}    7
    ${response}=      Cancelar Compra    ${token}
    Status Code Deve Ser    ${response}    200
    Mensagem Deve Ser       ${response}    Registro excluído com sucesso. Estoque dos produtos reabastecido
    Estoque Do Produto Deve Ser    ${id_produto}    10


*** Keywords ***
Preparar Produto
    ${token}=    Criar Usuario E Obter Token    administrador=true
    ${id}=       Criar Produto Valido    ${token}    quantidade=100
    Set Suite Variable    ${TOKEN_ADMIN}    ${token}
    Set Suite Variable    ${ID_PRODUTO}     ${id}

Estoque Do Produto Deve Ser
    [Arguments]    ${id_produto}    ${quantidade}
    ${response}=    Buscar Produto Por ID    ${id_produto}
    Should Be Equal As Integers    ${response.json()}[quantidade]    ${quantidade}
