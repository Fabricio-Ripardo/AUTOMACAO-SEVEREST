*** Settings ***
Documentation     Keywords da rota /carrinhos.
Resource          base.resource


*** Keywords ***
Cadastrar Carrinho
    [Arguments]    ${token}    ${id_produto}    ${quantidade}=1
    ${headers}=    Montar Headers    ${token}
    &{item}=       Create Dictionary    idProduto=${id_produto}    quantidade=${{int($quantidade)}}
    @{produtos}=   Create List    ${item}
    &{body}=       Create Dictionary    produtos=${produtos}
    ${response}=    POST    ${BASE_URL}/carrinhos    headers=${headers}    json=${body}    expected_status=anything
    RETURN    ${response}

Buscar Carrinho Por ID
    [Arguments]    ${id}
    ${response}=    GET    ${BASE_URL}/carrinhos/${id}    expected_status=anything
    RETURN    ${response}

Concluir Compra
    [Arguments]    ${token}
    ${headers}=    Montar Headers    ${token}
    ${response}=    DELETE    ${BASE_URL}/carrinhos/concluir-compra    headers=${headers}    expected_status=anything
    RETURN    ${response}

Cancelar Compra
    [Arguments]    ${token}
    ${headers}=    Montar Headers    ${token}
    ${response}=    DELETE    ${BASE_URL}/carrinhos/cancelar-compra    headers=${headers}    expected_status=anything
    RETURN    ${response}
