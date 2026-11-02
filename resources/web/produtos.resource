*** Settings ***
Documentation     Cadastro de produtos na área administrativa.
Resource          base.resource


*** Variables ***
${MENU_CADASTRAR_PRODUTOS}    css:[data-testid="cadastrarProdutos"]
${PRODUTO_NOME}               css:input[data-testid="nome"]
${PRODUTO_PRECO}              id:price
${PRODUTO_DESCRICAO}          id:description
${PRODUTO_QUANTIDADE}         id:quantity
${PRODUTO_CADASTRAR}          css:button[type="submit"]


*** Keywords ***
Acessar Cadastro De Produtos
    Clicar    ${MENU_CADASTRAR_PRODUTOS}
    Wait Until Element Is Visible    ${PRODUTO_NOME}

Cadastrar Produto Pela Interface
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}
    Preencher Campo    ${PRODUTO_NOME}          ${nome}
    Preencher Campo    ${PRODUTO_PRECO}         ${preco}
    Preencher Campo    ${PRODUTO_DESCRICAO}     ${descricao}
    Preencher Campo    ${PRODUTO_QUANTIDADE}    ${quantidade}
    Clicar    ${PRODUTO_CADASTRAR}

Produto Deve Aparecer Na Listagem
    [Arguments]    ${nome}
    Wait Until Location Contains    /admin/listarprodutos
    Wait Until Page Contains    ${nome}
