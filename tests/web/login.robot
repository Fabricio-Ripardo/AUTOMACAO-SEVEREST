*** Settings ***
Documentation     Testes de interface da tela de login.
Resource          ../../resources/web/login.resource
Test Setup        Abrir Navegador
Test Teardown     Fechar Navegador
Test Tags         web    login


*** Test Cases ***
Login de administrador leva para a area administrativa
    [Tags]    positivo
    ${admin}=    Criar Usuario Valido    administrador=true
    Entrar No Sistema    ${admin}[email]    ${admin}[password]
    Wait Until Location Contains    /admin/home

Login de usuario comum leva para a loja
    [Tags]    positivo
    ${usuario}=    Criar Usuario Valido    administrador=false
    Entrar No Sistema    ${usuario}[email]    ${usuario}[password]
    Wait Until Location Contains    /home
    ${url}=    Get Location
    Should Not Contain    ${url}    /admin

Login com senha incorreta
    [Tags]    negativo
    ${usuario}=    Criar Usuario Valido
    Entrar No Sistema    ${usuario}[email]    senhaIncorreta
    Wait Until Page Contains    Email e/ou senha inválidos
    Location Should Contain    /login

Login com email nao cadastrado
    [Tags]    negativo
    ${email}=    Gerar Email Aleatorio
    Entrar No Sistema    ${email}    ${SENHA_PADRAO}
    Wait Until Page Contains    Email e/ou senha inválidos
    Location Should Contain    /login
