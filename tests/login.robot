*** Settings ***
Documentation     Testes da rota /login da ServeRest.
Resource          ../resources/login.resource
Test Tags         login


*** Test Cases ***
Login com credenciais validas
    [Tags]    positivo
    ${usuario}=     Criar Usuario Valido
    ${response}=    Fazer Login    ${usuario}[email]    ${usuario}[password]
    Status Code Deve Ser    ${response}    200
    Mensagem Deve Ser       ${response}    Login realizado com sucesso
    Should Start With       ${response.json()}[authorization]    Bearer

Login com senha incorreta
    [Tags]    negativo
    ${usuario}=     Criar Usuario Valido
    ${response}=    Fazer Login    ${usuario}[email]    senhaErrada
    Status Code Deve Ser    ${response}    401
    Mensagem Deve Ser       ${response}    Email e/ou senha inválidos

Login com email nao cadastrado
    [Tags]    negativo
    ${email}=       Gerar Email Aleatorio
    ${response}=    Fazer Login    ${email}    ${SENHA_PADRAO}
    Status Code Deve Ser    ${response}    401
    Mensagem Deve Ser       ${response}    Email e/ou senha inválidos

Login sem informar o email
    [Tags]    negativo
    ${response}=    Fazer Login    ${EMPTY}    ${SENHA_PADRAO}
    Status Code Deve Ser    ${response}    400
    Dictionary Should Contain Key    ${response.json()}    email

Login sem informar a senha
    [Tags]    negativo
    ${usuario}=     Criar Usuario Valido
    ${response}=    Fazer Login    ${usuario}[email]    ${EMPTY}
    Status Code Deve Ser    ${response}    400
    Dictionary Should Contain Key    ${response.json()}    password
