*** Settings ***
Documentation     Página de login do front-end.
Resource          base.resource


*** Variables ***
${LOGIN_EMAIL}       id:email
${LOGIN_SENHA}       id:password
${LOGIN_ENTRAR}      css:button[type="submit"]


*** Keywords ***
Entrar No Sistema
    [Arguments]    ${email}    ${senha}
    Preencher Campo    ${LOGIN_EMAIL}    ${email}
    Preencher Campo    ${LOGIN_SENHA}    ${senha}
    Clicar    ${LOGIN_ENTRAR}

Entrar Como Administrador
    [Documentation]    Cria um administrador novo pela API e faz login pela interface.
    ${admin}=    Criar Usuario Valido    administrador=true
    Entrar No Sistema    ${admin}[email]    ${admin}[password]
    Wait Until Location Contains    /admin/home
