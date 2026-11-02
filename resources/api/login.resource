*** Settings ***
Documentation     Keywords da rota /login.
Resource          base.resource
Resource          usuarios.resource


*** Keywords ***
Fazer Login
    [Arguments]    ${email}    ${password}
    ${headers}=    Montar Headers
    &{body}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    ${BASE_URL}/login    headers=${headers}    json=${body}    expected_status=anything
    RETURN    ${response}

Obter Token
    [Documentation]    Faz login e devolve o token "Bearer ..." para usar nas rotas protegidas.
    [Arguments]    ${email}    ${password}
    ${response}=    Fazer Login    ${email}    ${password}
    Status Code Deve Ser    ${response}    200
    RETURN    ${response.json()}[authorization]

Criar Usuario E Obter Token
    [Documentation]    Cria um usuário novo (admin ou não) e já devolve o token dele.
    [Arguments]    ${administrador}=true
    ${usuario}=    Criar Usuario Valido    administrador=${administrador}
    ${token}=      Obter Token    ${usuario}[email]    ${usuario}[password]
    RETURN    ${token}
