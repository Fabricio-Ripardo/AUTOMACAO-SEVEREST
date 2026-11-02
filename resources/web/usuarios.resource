*** Settings ***
Documentation     Cadastro de usuários na área administrativa.
Resource          base.resource


*** Variables ***
${MENU_CADASTRAR_USUARIOS}    css:[data-testid="cadastrarUsuarios"]
${USUARIO_NOME}               css:input[data-testid="nome"]
${USUARIO_EMAIL}              id:email
${USUARIO_SENHA}              id:password
${USUARIO_ADMIN}              id:administrador
${USUARIO_CADASTRAR}          css:button[type="submit"]


*** Keywords ***
Acessar Cadastro De Usuarios
    Clicar    ${MENU_CADASTRAR_USUARIOS}
    Wait Until Element Is Visible    ${USUARIO_NOME}

Cadastrar Usuario Pela Interface
    [Arguments]    ${nome}    ${email}    ${senha}    ${administrador}=${False}
    Preencher Campo    ${USUARIO_NOME}     ${nome}
    Preencher Campo    ${USUARIO_EMAIL}    ${email}
    Preencher Campo    ${USUARIO_SENHA}    ${senha}
    IF    ${administrador}    Clicar    ${USUARIO_ADMIN}
    Clicar    ${USUARIO_CADASTRAR}

Usuario Deve Aparecer Na Listagem
    [Arguments]    ${email}
    Wait Until Location Contains    /admin/listarusuarios
    Wait Until Page Contains    ${email}
