*** Settings ***
Documentation     Testes de interface do cadastro de usuários (área administrativa).
Resource          ../../resources/web/login.resource
Resource          ../../resources/web/usuarios.resource
Test Setup        Abrir Navegador E Ir Para Cadastro De Usuarios
Test Teardown     Fechar Navegador
Test Tags         web    usuarios


*** Test Cases ***
Cadastrar usuario administrador
    [Tags]    positivo
    ${email}=    Gerar Email Aleatorio
    Cadastrar Usuario Pela Interface    Usuario Web    ${email}    ${SENHA_PADRAO}    administrador=${True}
    Usuario Deve Aparecer Na Listagem    ${email}

Cadastrar usuario comum
    [Tags]    positivo
    ${email}=    Gerar Email Aleatorio
    Cadastrar Usuario Pela Interface    Usuario Web    ${email}    ${SENHA_PADRAO}
    Usuario Deve Aparecer Na Listagem    ${email}

Nao deve cadastrar usuario com email ja utilizado
    [Tags]    negativo
    ${existente}=    Criar Usuario Valido
    Cadastrar Usuario Pela Interface    Outro Nome    ${existente}[email]    ${SENHA_PADRAO}
    Wait Until Page Contains    Este email já está sendo usado

Nao deve cadastrar usuario sem nome
    [Tags]    negativo
    ${email}=    Gerar Email Aleatorio
    Cadastrar Usuario Pela Interface    ${EMPTY}    ${email}    ${SENHA_PADRAO}
    Wait Until Page Contains    Nome é obrigatório

Nao deve cadastrar usuario sem email
    [Tags]    negativo
    Cadastrar Usuario Pela Interface    Usuario Web    ${EMPTY}    ${SENHA_PADRAO}
    Wait Until Page Contains    Email é obrigatório

Nao deve cadastrar usuario sem senha
    [Tags]    negativo
    ${email}=    Gerar Email Aleatorio
    Cadastrar Usuario Pela Interface    Usuario Web    ${email}    ${EMPTY}
    Wait Until Page Contains    Password é obrigatório


*** Keywords ***
Abrir Navegador E Ir Para Cadastro De Usuarios
    Abrir Navegador
    Entrar Como Administrador
    Acessar Cadastro De Usuarios
