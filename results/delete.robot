*** Settings ***
Library    RequestsLibrary
Library    String

*** Variables ***
${HOST}                 https://serverest.dev
${DELETE_USER}          usuarios
${DELETE_PRODUCT}       produtos
${CONCLUIR_COMPRA}      carrinhos/concluir-compra
${CANCELAR_COMPRA}      carrinhos/cancelar-compra

*** Keywords ***
Fazer login
    &{headers}    Create Dictionary    Content-Type=application/json
    &{body}       Create Dictionary
    ...    email=kayn@teste.com
    ...    password=1234

    ${response}=    POST    ${HOST}/login    headers=${headers}    json=${body}
    ${token}=       Set Variable    ${response.json()}[authorization]
    RETURN    ${token}

Deletar usuario
    [Arguments]    ${id}    ${token}
    &{headers}    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=${token}

    DELETE    ${HOST}/${DELETE_USER}/${id}    headers=${headers}

Deletar um produto
    [Arguments]    ${id}    ${token}
    &{headers}    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=${token}

    DELETE    ${HOST}/${DELETE_PRODUCT}/${id}    headers=${headers}

Concluir uma compra
    [Arguments]    ${token}
    &{headers}    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=${token}

    DELETE    ${HOST}/${CONCLUIR_COMPRA}    headers=${headers}

Cancelar uma compra
    [Arguments]    ${token}
    &{headers}    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=${token}

    DELETE    ${HOST}/${CANCELAR_COMPRA}    headers=${headers}

*** Test Cases ***
Deletar um usuario
    ${token}=    Fazer login
    Deletar usuario    DY7OW7acLlGq4EZs    ${token}

Deletar produto
    ${token}=    Fazer login
    Deletar um produto    e9M7RPIGpZKF23qT    ${token}

Concluir compra
    ${token}=    Fazer login
    Concluir uma compra    ${token}

Cancelar compra
    ${token}=    Fazer login
    Cancelar uma compra    ${token}