*** Settings ***
Documentation     Keywords da rota /produtos.
Resource          base.resource


*** Keywords ***
Cadastrar Produto
    [Arguments]    ${token}    ${nome}    ${preco}=100    ${descricao}=Produto de teste    ${quantidade}=10
    ${headers}=    Montar Headers    ${token}
    &{body}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${{int($preco)}}
    ...    descricao=${descricao}
    ...    quantidade=${{int($quantidade)}}
    ${response}=    POST    ${BASE_URL}/produtos    headers=${headers}    json=${body}    expected_status=anything
    RETURN    ${response}

Criar Produto Valido
    [Documentation]    Cria um produto com nome aleatório e devolve o id.
    [Arguments]    ${token}    ${quantidade}=10
    ${nome}=        Gerar Nome Aleatorio    Produto
    ${response}=    Cadastrar Produto    ${token}    ${nome}    quantidade=${quantidade}
    Status Code Deve Ser    ${response}    201
    RETURN    ${response.json()}[_id]

Buscar Produto Por ID
    [Arguments]    ${id}
    ${response}=    GET    ${BASE_URL}/produtos/${id}    expected_status=anything
    RETURN    ${response}

Listar Produtos
    ${response}=    GET    ${BASE_URL}/produtos    expected_status=anything
    RETURN    ${response}

Editar Produto
    [Arguments]    ${token}    ${id}    ${nome}    ${preco}    ${descricao}    ${quantidade}
    ${headers}=    Montar Headers    ${token}
    &{body}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${{int($preco)}}
    ...    descricao=${descricao}
    ...    quantidade=${{int($quantidade)}}
    ${response}=    PUT    ${BASE_URL}/produtos/${id}    headers=${headers}    json=${body}    expected_status=anything
    RETURN    ${response}

Excluir Produto
    [Arguments]    ${token}    ${id}
    ${headers}=    Montar Headers    ${token}
    ${response}=    DELETE    ${BASE_URL}/produtos/${id}    headers=${headers}    expected_status=anything
    RETURN    ${response}
