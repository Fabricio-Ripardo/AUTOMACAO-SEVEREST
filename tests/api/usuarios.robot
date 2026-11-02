*** Settings ***
Documentation     Testes da rota /usuarios da ServeRest.
Resource          ../../resources/api/usuarios.resource
Test Tags         api    usuarios


*** Test Cases ***
Cadastrar usuario com dados validos
    [Tags]    positivo
    ${nome}=     Gerar Nome Aleatorio    Usuario
    ${email}=    Gerar Email Aleatorio
    ${response}=    Cadastrar Usuario    ${nome}    ${email}
    Status Code Deve Ser    ${response}    201
    Mensagem Deve Ser       ${response}    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    _id

Nao deve cadastrar usuario com email ja utilizado
    [Tags]    negativo
    ${usuario}=     Criar Usuario Valido
    ${response}=    Cadastrar Usuario    Outro Nome    ${usuario}[email]
    Status Code Deve Ser    ${response}    400
    Mensagem Deve Ser       ${response}    Este email já está sendo usado

Nao deve cadastrar usuario sem email
    [Tags]    negativo
    ${response}=    Cadastrar Usuario    Usuario Sem Email    ${EMPTY}
    Status Code Deve Ser    ${response}    400
    Dictionary Should Contain Key    ${response.json()}    email

Listar usuarios
    [Tags]    positivo
    ${response}=    Listar Usuarios
    Status Code Deve Ser    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    quantidade
    Dictionary Should Contain Key    ${response.json()}    usuarios

Filtrar usuarios por email
    [Tags]    positivo
    ${usuario}=     Criar Usuario Valido
    ${response}=    Listar Usuarios    email=${usuario}[email]
    Status Code Deve Ser    ${response}    200
    Should Be Equal As Integers    ${response.json()}[quantidade]    1
    Should Be Equal    ${response.json()}[usuarios][0][_id]    ${usuario}[id]

Buscar usuario por ID
    [Tags]    positivo
    ${usuario}=     Criar Usuario Valido
    ${response}=    Buscar Usuario Por ID    ${usuario}[id]
    Status Code Deve Ser    ${response}    200
    Should Be Equal    ${response.json()}[nome]     ${usuario}[nome]
    Should Be Equal    ${response.json()}[email]    ${usuario}[email]

Buscar usuario com ID inexistente
    [Tags]    negativo
    ${response}=    Buscar Usuario Por ID    idInexistente123
    Status Code Deve Ser    ${response}    400
    Mensagem Deve Ser       ${response}    Usuário não encontrado

Editar usuario
    [Tags]    positivo
    ${usuario}=      Criar Usuario Valido
    ${novo_email}=   Gerar Email Aleatorio
    ${response}=     Editar Usuario    ${usuario}[id]    Nome Atualizado    ${novo_email}
    Status Code Deve Ser    ${response}    200
    Mensagem Deve Ser       ${response}    Registro alterado com sucesso
    ${consulta}=     Buscar Usuario Por ID    ${usuario}[id]
    Should Be Equal    ${consulta.json()}[nome]     Nome Atualizado
    Should Be Equal    ${consulta.json()}[email]    ${novo_email}

Excluir usuario
    [Tags]    positivo
    ${usuario}=     Criar Usuario Valido
    ${response}=    Excluir Usuario    ${usuario}[id]
    Status Code Deve Ser    ${response}    200
    Mensagem Deve Ser       ${response}    Registro excluído com sucesso
    ${consulta}=    Buscar Usuario Por ID    ${usuario}[id]
    Status Code Deve Ser    ${consulta}    400

Excluir usuario inexistente nao remove nenhum registro
    [Tags]    negativo
    ${response}=    Excluir Usuario    idInexistente123
    Status Code Deve Ser    ${response}    200
    Mensagem Deve Ser       ${response}    Nenhum registro excluído
