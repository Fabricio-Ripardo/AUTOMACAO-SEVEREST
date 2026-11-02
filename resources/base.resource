*** Settings ***
Documentation     Configuração comum e keywords de apoio usadas por todas as suítes.
Library           RequestsLibrary
Library           String
Library           Collections


*** Variables ***
${BASE_URL}       https://serverest.dev
${SENHA_PADRAO}   senha@teste123


*** Keywords ***
Gerar Email Aleatorio
    [Documentation]    Gera um e-mail único para que cada execução use dados novos.
    ${sufixo}=    Generate Random String    10    [LOWER][NUMBERS]
    RETURN    qa.${sufixo}@teste.com

Gerar Nome Aleatorio
    [Arguments]    ${prefixo}=Teste
    ${sufixo}=    Generate Random String    8    [LETTERS][NUMBERS]
    RETURN    ${prefixo} ${sufixo}

Montar Headers
    [Documentation]    Headers padrão. Se receber um token, adiciona o Authorization.
    [Arguments]    ${token}=${None}
    &{headers}=    Create Dictionary    Content-Type=application/json
    IF    $token is not None
        Set To Dictionary    ${headers}    Authorization=${token}
    END
    RETURN    ${headers}

Status Code Deve Ser
    [Arguments]    ${response}    ${esperado}
    Should Be Equal As Integers    ${response.status_code}    ${esperado}
    ...    msg=Status esperado ${esperado}, recebido ${response.status_code}: ${response.text}

Mensagem Deve Ser
    [Arguments]    ${response}    ${mensagem}
    Should Be Equal As Strings    ${response.json()}[message]    ${mensagem}
