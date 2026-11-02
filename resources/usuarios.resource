*** Settings ***
Documentation     Keywords da rota /usuarios.
Resource          base.resource


*** Keywords ***
Cadastrar Usuario
    [Documentation]    Envia o cadastro e devolve a resposta, sem validar (para cenários positivos e negativos).
    [Arguments]    ${nome}    ${email}    ${password}=${SENHA_PADRAO}    ${administrador}=true
    ${headers}=    Montar Headers
    &{body}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrador}
    ${response}=    POST    ${BASE_URL}/usuarios    headers=${headers}    json=${body}    expected_status=anything
    RETURN    ${response}

Criar Usuario Valido
    [Documentation]    Cria um usuário com dados aleatórios e devolve um dicionário com id, nome, email e senha.
    [Arguments]    ${administrador}=true
    ${nome}=     Gerar Nome Aleatorio    Usuario
    ${email}=    Gerar Email Aleatorio
    ${response}=    Cadastrar Usuario    ${nome}    ${email}    administrador=${administrador}
    Status Code Deve Ser    ${response}    201
    &{usuario}=    Create Dictionary
    ...    id=${response.json()}[_id]
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${SENHA_PADRAO}
    ...    administrador=${administrador}
    RETURN    ${usuario}

Buscar Usuario Por ID
    [Arguments]    ${id}
    ${response}=    GET    ${BASE_URL}/usuarios/${id}    expected_status=anything
    RETURN    ${response}

Listar Usuarios
    [Arguments]    &{filtros}
    ${response}=    GET    ${BASE_URL}/usuarios    params=${filtros}    expected_status=anything
    RETURN    ${response}

Editar Usuario
    [Arguments]    ${id}    ${nome}    ${email}    ${password}=${SENHA_PADRAO}    ${administrador}=true
    ${headers}=    Montar Headers
    &{body}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${administrador}
    ${response}=    PUT    ${BASE_URL}/usuarios/${id}    headers=${headers}    json=${body}    expected_status=anything
    RETURN    ${response}

Excluir Usuario
    [Arguments]    ${id}
    ${response}=    DELETE    ${BASE_URL}/usuarios/${id}    expected_status=anything
    RETURN    ${response}
