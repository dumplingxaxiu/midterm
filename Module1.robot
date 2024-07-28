*** Settings ***
Library           SeleniumLibrary
Library           Collections

*** Variables ***
${Browser}        Chrome
${URL}            https://www.saucedemo.com/
${username}       xpath =//*[@id="user-name"]
${password}       xpath=//*[@id="password"]
${LoginButton}    xpath=//*[@id="login-button"]
${error}          xpath=//*[@id="login_button_container"]/div/form/div[3]/h3
${correct_username}    standard_user
${correct_password}    secret_sauce
${incorrect_username}    incorrect_username
${incorrect_password}    incorrect_password
${locked_out_username}    locked_out_user
${menu_button}    xpath=//*[@id="react-burger-menu-btn"]
${logout_link}    xpath=//*[@id="logout_sidebar_link"]
${SortDropdown}    xpath=//*[@id="header_container"]/div[2]/div/span/select
${SortOptionAZ}    xpath=//*[@id="header_container"]/div[2]/div/span/select/option[1]
${SortOptionZA}    xpath=//*[@id="header_container"]/div[2]/div/span/select/option[2]
${product_list}    css=.inventory_item
${ProductList}    css=.inventory_list
${SortOptionLowToHigh}    xpath=//*[@id="header_container"]/div[2]/div/span/select/option[3]
${SortOptionHighToLow}    xpath= //*[@id="header_container"]/div[2]/div/span/select/option[4]
${ProductPrice}    css=.inventory_item_price
${ProductNames}    xpath=//div[@class='inventory_item_name']

*** Test Cases ***
Module1_1
    [Documentation]    Check login with correct username and password
    Open Browser    ${URL}    ${Browser}
    Wait until page contains    Swag Labs
    Input_text    ${username}    ${correct_username}
    Input_text    ${password}    ${correct_password}
    Click_element    ${LoginButton}
    Page should not contain    Epic sadface: Username and password do not match any user in this service
    Close browser

Module1_2
    [Documentation]    Check login with correct username & incorrect password
    Open Browser    ${URL}    ${Browser}
    Wait until page contains    Swag Labs
    Input_text    ${username}    ${correct_username}
    Input_text    ${password}    ${incorrect_password}
    Click_element    ${LoginButton}
    Page should contain    Epic sadface: Username and password do not match any user in this service
    Close browser

Module1_3
    [Documentation]    Check login with incorrect user name & correct password
    Open Browser    ${URL}    ${Browser}
    Wait until page contains    Swag Labs
    Input_text    ${username}    ${incorrect_username}
    Input_text    ${password}    ${correct_password}
    Click_element    ${LoginButton}
    Page should contain    Epic sadface: Username and password do not match any user in this service
    Close browser

Module1_4
    [Documentation]    Check login and leave the password blank
    Open Browser    ${URL}    ${Browser}
    Wait until page contains    Swag Labs
    Input_text    ${username}    ${correct_username}
    Click_element    ${LoginButton}
    Page should contain    Epic sadface: Password is required
    Close browser

Module1_5
    [Documentation]    Check login and leave the username blank
    Open Browser    ${URL}    ${Browser}
    Wait until page contains    Swag Labs
    Input_text    ${password}    ${correct_password}
    Click_element    ${LoginButton}
    Page should contain    Epic sadface: Username is required
    Close browser

Module1_6
    [Documentation]    Check login with blank username and password
    Open Browser    ${URL}    ${Browser}
    Wait until page contains    Swag Labs
    Click_element    ${LoginButton}
    Page should contain    Epic sadface: Username is required
    Close browser

Module1_7
    [Documentation]    Check login with locked username
    Open Browser    ${URL}    ${Browser}
    Wait until page contains    Swag Labs
    Input_text    ${username}    ${locked_out_username}
    Input_text    ${password}    ${correct_password}
    Click_element    ${LoginButton}
    Page should contain    Epic sadface: Sorry, this user has been locked out.
    Close browser

Module1_8
    [Documentation]    Check logout functionality
    Open Browser    ${URL}    ${Browser}
    Wait Until Page Contains    Swag Labs
    Input_text    ${username}    ${correct_username}
    Input_text    ${password}    ${correct_password}
    Click Element    ${LoginButton}
    Wait Until Page Contains    All Items    timeout=10s
    Click Element    ${menu_button}
    ${logout_link_visible}    Wait Until Element Is Visible    ${logout_link}
    Run Keyword If    '${logout_link_visible}' == 'True'    Click Element    ${logout_link}
    Close Browser