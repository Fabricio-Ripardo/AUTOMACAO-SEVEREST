*** Settings ***
Library    RequestsLibrary
Library    String
*** Variables ***
${HOST}    https://serverest.dev

${GET_ALL_USERS}    /usuarios

${GET_ALL_PRODUCTS}    /produtos

${GET_CART}    /carrinhos
*** Keywords ***
Pegar Todos Os Usuarios
    &{headers}    Create Dictionary    Content-Type=application/json

    GET    ${HOST}/${GET_ALL_USERS}    headers=${headers}
Pegar um Usuario Por ID
    [Arguments]    ${id}
    &{headers}    Create Dictionary    Content-Type=application/json
    ${rota}=  Set Variable    usuarios/${id}
    GET    ${HOST}/${rota}    headers=${headers} 
Pegar Todos Os Produtos
    &{headers}    Create Dictionary    Content-Type=application/json

    GET    ${HOST}/${GET_ALL_PRODUCTS}    headers=${headers}
Pegar um Produto Por ID
    [Arguments]    ${id}
    &{headers}    Create Dictionary    Content-Type=application/json
    ${rota}=  Set Variable    produtos/${id}
    GET    ${HOST}/${rota}    headers=${headers}
Pegar o carrinho de compras
    &{headers}    Create Dictionary    Content-Type=application/json

    GET    ${HOST}/${GET_CART}    headers=${headers}
Pegar um carrinho de compras por ID
    [Arguments]    ${id}
    &{headers}    Create Dictionary    Content-Type=application/json
    ${rota}=  Set Variable    carrinhos/${id}
    GET    ${HOST}/${rota}    headers=${headers}
*** Test Cases ***
Realizar Consulta De Todos Os Usuarios
    Pegar Todos Os Usuarios
Realizar Consulta De Um Usuario Por ID
    Pegar um Usuario Por ID    0uxuPY0cbmQhpEz1
Realizar Consulta De Todos Os Produtos
    Pegar Todos Os Produtos
Realizar Consulta De Um Produto Por ID
    Pegar um Produto Por ID    BeeJh5lz3k6kSIzA
Realizar Consulta Do Carrinho De Compras
    Pegar o carrinho de compras
Realizar Consulta De Um Carrinho De Compras Por ID
    Pegar um carrinho de compras por ID    qbMqntef4iTOwWfg