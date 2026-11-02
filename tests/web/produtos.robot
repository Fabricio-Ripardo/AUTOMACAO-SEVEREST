*** Settings ***
Documentation     Testes de interface do cadastro de produtos (área administrativa).
Resource          ../../resources/web/login.resource
Resource          ../../resources/web/produtos.resource
Test Setup        Abrir Navegador E Ir Para Cadastro De Produtos
Test Teardown     Fechar Navegador
Test Tags         web    produtos


*** Test Cases ***
Cadastrar produto
    [Tags]    positivo
    ${nome}=    Gerar Nome Aleatorio    Produto Web
    Cadastrar Produto Pela Interface    ${nome}    150    Produto criado pela interface    10
    Produto Deve Aparecer Na Listagem    ${nome}

Nao deve cadastrar produto sem nome
    [Tags]    negativo
    Cadastrar Produto Pela Interface    ${EMPTY}    150    Produto sem nome    10
    Wait Until Page Contains    Nome é obrigatório

Nao deve cadastrar produto sem preco
    [Tags]    negativo
    ${nome}=    Gerar Nome Aleatorio    Produto Web
    Cadastrar Produto Pela Interface    ${nome}    ${EMPTY}    Produto sem preco    10
    Wait Until Page Contains    Preco é obrigatório

Nao deve cadastrar produto sem descricao
    [Tags]    negativo
    ${nome}=    Gerar Nome Aleatorio    Produto Web
    Cadastrar Produto Pela Interface    ${nome}    150    ${EMPTY}    10
    Wait Until Page Contains    Descricao é obrigatório


*** Keywords ***
Abrir Navegador E Ir Para Cadastro De Produtos
    Abrir Navegador
    Entrar Como Administrador
    Acessar Cadastro De Produtos
