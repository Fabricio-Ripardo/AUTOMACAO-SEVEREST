*** Settings ***
Documentation     Configuração dos testes de interface (front-end da ServeRest).
...               Os dados de apoio (usuários, produtos) são criados pela API, o que deixa os testes
...               de interface mais rápidos e focados no que realmente estão testando.
Library           SeleniumLibrary    timeout=10s    screenshot_root_directory=EMBED
Resource          ../api/login.resource


*** Variables ***
${URL_FRONT}      https://front.serverest.dev
${BROWSER}        chrome


*** Keywords ***
Abrir Navegador
    Open Browser    ${URL_FRONT}/login    ${BROWSER}
    Set Window Size    1920    1080

Fechar Navegador
    Run Keyword If Test Failed    Capture Page Screenshot
    Close Browser

Preencher Campo
    [Documentation]    Espera o campo aparecer antes de digitar (evita falhas de sincronização).
    [Arguments]    ${locator}    ${texto}
    Wait Until Element Is Visible    ${locator}
    Input Text    ${locator}    ${texto}

Clicar
    [Arguments]    ${locator}
    Wait Until Element Is Enabled    ${locator}
    Click Element    ${locator}
