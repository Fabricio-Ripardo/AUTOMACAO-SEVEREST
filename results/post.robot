*** Settings ***
Library    RequestsLibrary
Library    String
*** Variables ***
${HOST}    https://serverest.dev


${ADD_USER}    usuarios
*** Keywords ***
Adicionar um novo usuario
    &{headers}    Create Dictionary    Content-Type=application/json

    &{body}    Create Dictionary    nome=juan    email=juan@teste.com   password=1234    administrador=true

    POST    url=${HOST}/${ADD_USER}    headers=${headers}    json=${body}

Fazer um login de usuario
    [Arguments]    ${email}    ${password}
    &{headers}    Create Dictionary    Content-Type=application/json

    &{body}    Create Dictionary    
    ...    email=${email}    
    ...    password=${password}

Adicionar um novo produto
    &{headers}    Create Dictionary    Content-Type=application/json

    &{body}    Create Dictionary    
    ...    nome=ProdutoTeste    
    ...    preco=100    
    ...    descricao=Descricao do produto teste    
    ...    quantidade=10
Adicionar um carrinho de compras
    &{headers}    Create Dictionary    Content-Type=application/json

    &{body}    Create Dictionary    
    ...    produtos=[{"idProduto": "12345", "quantidade": 2}]
*** Test Cases ***
Realizar Cadastro De Um Usuario
    Adicionar um novo usuario
Realizar login de usuario
    Fazer um login de usuario    email=testeteste@teste.com    password=1234
Adicionar um novo produto
    Adicionar um novo produto
Adicionar um carrinho de compras
    Adicionar um carrinho de compras