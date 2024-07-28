*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${browser}        fire fox
${URL}            https://www.saucedemo.com/
${username}       xpath =//*[@id="user-name"]
${password}       xpath=//*[@id="password"]
${loginButton}    xpath=//*[@id="login-button"]
${correct_username}    standard_user
${correct_password}    secret_sauce
${inventory}      css=.inventory_list
${products}       css=.inventory_item
${product4}       xpath=/html/body/div/div/div/div[2]/div/div/div/div[1]/div[1]/a
${product4_img}    xpath=/html/body/div/div/div/div[2]/div/div/div[1]/img
${product4_img_atInventory}    xpath=/html/body/div/div/div/div[2]/div/div/div/div[1]/div[1]/a/img
${product4_name_text}    Sauce Labs Backpack
${product4_name}    xpath=/html/body/div/div/div/div[2]/div/div/div[2]/div[1]
${product4_name_atInventory}    xpath=/html/body/div/div/div/div[2]/div/div/div/div[1]/div[2]/div[1]/a/div
${product4_details}    xpath=/html/body/div/div/div/div[2]/div/div/div[2]/div[2]
${product4_details_atInventory}    xpath=/html/body/div/div/div/div[2]/div/div/div/div[1]/div[2]/div[1]/div
${product4_price}    xpath=/html/body/div/div/div/div[2]/div/div/div[2]/div[3]
${product4_price_atInventory}    xpath=/html/body/div/div/div/div[2]/div/div/div/div[1]/div[2]/div[2]/div

*** Test Cases ***
Module2_1
    [Documentation]    Check product information is displayed correct at inventory page
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}\n
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Wait Until Page Contains Element    ${product4}
    Close Browser

Module2_2
    [Documentation]    Check product image is displayed correct at inventory page
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Wait Until Page Contains Element    ${product4}
    Wait Until Page Contains Element    ${product4_img_atInventory}    timeout=10s
    Close Browser

Module2_3
    [Documentation]    Check product name is displayed correct at inventory page
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Wait Until Page Contains Element    ${product4}
    Wait Until Page Contains Element    ${product4_name_atInventory}    timeout=10s
    Close Browser

Module2_4
    [Documentation]    Check product details is displayed correct at inventory page
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Wait Until Page Contains Element    ${product4}
    Wait Until Page Contains Element    ${product4_details_atInventory}    timeout=10s
    Close Browser

Module2_5
    [Documentation]    Check product price is displayed correct at inventory page
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Wait Until Page Contains Element    ${product4}
    Wait Until Page Contains Element    ${product4_price_atInventory}    timeout=10s
    Close Browser

Module2_6
    [Documentation]    Check product image is displayed after clicking the product
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}\n
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Click Element    ${product4}
    Wait Until Page Contains Element    ${product4_img}    timeout=10s
    Close Browser

Module2_7
    [Documentation]    Check product name is displayed after clicking the product
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Click Element    ${product4}
    Wait Until Page Contains Element    ${product4_name}    timeout=10s
    Close Browser

Module2_8
    [Documentation]    Check product details is displayed after clicking the product
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Click Element    ${product4}
    Wait Until Page Contains Element    ${product4_details}    timeout=10s
    Close Browser

Module2_9
    [Documentation]    Check product price is displayed after clicking the product
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Button    ${loginButton}
    Click Element    ${inventory}
    Click Element    ${product4}
    Wait Until Page Contains Element    ${product4_price}    timeout=10s
    Close Browser
