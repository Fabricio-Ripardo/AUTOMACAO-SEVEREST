*** Settings ***
Library   RequestsLibrary
*** Variables ***
${HOST}    https://serverest.dev

${PUT_USER}    usuarios
${PUT_PRODUCT}    produtos
*** Keywords ***
Fazer login
    &{headers}    Create Dictionary    Content-Type=application/json
    &{body}       Create Dictionary
    ...    email=kayn@teste.com
    ...    password=1234

    ${response}=    POST    ${HOST}/login    headers=${headers}    json=${body}
    ${token}=       Set Variable    ${response.json()}[authorization]
    RETURN    ${token}
Atualizar usuario
    [Arguments]    ${id}    ${token}
    &{headers}    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=${token}

    &{body}       Create Dictionary
    ...    nome=UsuarioAtualizado
    ...    email=usuarioatualizado123@teste.com
    ...    password=1234
    ...    administrador=true
    PUT    ${HOST}/${PUT_USER}/${id}    headers=${headers}    json=${body}
Atualizar um produto
    [Arguments]    ${id}    ${token}
    &{headers}    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=${token}

    &{body}    Create Dictionary
    ...    nome=ProdutoAtualizado
    ...    preco=150
    ...    descricao=Descricao do produto atualizado
    ...    quantidade=20
    PUT    ${HOST}/${PUT_PRODUCT}/${id}    headers=${headers}    json=${body}
*** Test Cases ***
Atualizar um usuario
    ${token}=    Fazer login
    Atualizar usuario    DY7OW7acLlGq4EZs    ${token}
Atualizar produto
    ${token}=    Fazer login
    Atualizar um produto    BeeJh5lz3k6kSIzA    ${token}