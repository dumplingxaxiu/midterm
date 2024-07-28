*** Settings ***
Library           SeleniumLibrary
Library           Collections

*** Variables ***
${browser}        Chrome
${URL}            https://www.saucedemo.com/
${username}       xpath =//*[@id="user-name"]
${password}       xpath=//*[@id="password"]
${LoginButton}    xpath=//*[@id="login-button"]
${error}          xpath=//*[@id="login_button_container"]/div/form/div[3]/h3
${correct_username}    standard_user
${correct_password}    secret_sauce
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
Module3_1
    [Documentation]    Sort products from A to Z on SauceDemo website
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Element    ${LoginButton}
    Wait Until Page Contains Element    ${ProductList}
    ${product_elements}    Get WebElements    ${ProductNames}
    ${product_names}    Create List
    FOR    ${element}    IN    @{product_elements}
        ${text}    Get Text    ${element}
        Append To List    ${product_names}    ${text}
    END
    Log    Product Names: ${product_names}    # Hiển thị danh sách tên sản phẩm trong log
    Close Browser

Module3_2
    [Documentation]    Sort products from Z to A on SauceDemo website
    Open Browser    ${URL}    ${Browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Element    ${LoginButton}
    Wait Until Page Contains Element    ${ProductList}
    ${product_elements}    Get WebElements    ${ProductNames}
    ${product_names}    Create List
    FOR    ${element}    IN    @{product_elements}
        ${text}    Get Text    ${element}
        Append To List    ${product_names}    ${text}
    END
    ${sorted_product_names}    Evaluate    sorted(${product_names}, reverse=True)
    Log    Product Names (Z to A): ${sorted_product_names}    # Hiển thị danh sách tên sản phẩm đã được sắp xếp trong log
    Close Browser

Module3_3
    [Documentation]    Sort products from high to low on SauceDemo website
    Open Browser    ${URL}    ${Browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Element    ${LoginButton}
    Wait Until Page Contains Element    ${ProductList}
    Click Element    ${SortDropdown}
    Click Element    ${SortOptionHighToLow}
    Wait Until Page Contains Element    ${ProductList}
    ${product_elements}    Get WebElements    ${ProductPrice}
    ${product_prices}    Create List
    FOR    ${element}    IN    @{product_elements}
        ${text}    Get Text    ${element}
        Append To List    ${product_prices}    ${text}
    END
    ${sorted_prices}    Evaluate    sorted(${product_prices}, key=lambda x: float(x[1:].replace('$', '')), reverse=True)
    Lists Should Be Equal    ${product_prices}    ${sorted_prices}
    Close Browser

Module3_4
    [Documentation]    Sort products from low to high on SauceDemo website
    Open Browser    ${URL}    ${Browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Element    ${LoginButton}
    Wait Until Page Contains Element    ${ProductList}
    Click Element    ${SortDropdown}
    Click Element    ${SortOptionLowToHigh}
    Wait Until Page Contains Element    ${ProductList}
    ${product_elements}    Get WebElements    ${ProductPrice}
    ${product_prices}    Create List
    FOR    ${element}    IN    @{product_elements}
        ${text}    Get Text    ${element}
        Append To List    ${product_prices}    ${text}
    END
    ${sorted_prices}    Evaluate    sorted(${product_prices}, key=lambda x: float(x[1:].replace('$', '')))
    Lists Should Be Equal    ${product_prices}    ${sorted_prices}
    Close Browser

Module3_5
    [Documentation]    Go Back From Cart
    Open Browser    ${URL}    ${browser}
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Element    ${LoginButton}
    Click Element    xpath=//*[@id="shopping_cart_container"]/a
    Click Element    xpath=//*[@id="continue-shopping"]
    Wait Until Page Contains Element    ${ProductList}

Module3_6
    [Documentation]    Cancel Checkout
    Open Browser    ${URL}    fire fox
    Input Text    ${username}    ${correct_username}
    Input Text    ${password}    ${correct_password}
    Click Element    ${LoginButton}
    Click Element    xpath=//*[@id="shopping_cart_container"]/a
    Click Element    xpath=//*[@id="checkout"]
    Click Element    xpath=//*[@id="cancel"]
    Wait Until Page Contains Element    xpath=//*[@id="cart_contents_container"]/div/div[1]
