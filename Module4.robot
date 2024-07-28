*** Settings ***
Suite Teardown    Close Browser
Library           SeleniumLibrary
Library           String

*** Variables ***
${Browser}        Chrome
${URL}            https://www.saucedemo.com/
${username}       xpath =//*[@id="user-name"]
${password}       xpath=//*[@id="password"]
${button}         xpath=//*[@id="login-button"]
${error}          xpath=//*[@id="login_button_container"]/div/form/div[3]/h3
${correct_username}    standard_user
${correct_password}    secret_sauce
${incorrect_username}    incorrect_username
${incorrect_password}    incorrect_password
${locked_out_username}    locked_out_user
${menu_button}    xpath=//*[@id="react-burger-menu-btn"]
${logout_link}    xpath=//*[@id="logout_sidebar_link"]
${cart_count_xpath}    //*[@id="shopping_cart_container"]/a/span
@{PRODUCT_XPATHS}    //*[@id="add-to-cart-sauce-labs-backpack"]    //*[@id="add-to-cart-sauce-labs-bike-light"]    //*[@id="add-to-cart-sauce-labs-bolt-t-shirt"]    //*[@id="add-to-cart-sauce-labs-fleece-jacket"]    //*[@id="add-to-cart-sauce-labs-onesie"]    //*[@id="add-to-cart-test.allthethings()-t-shirt-(red)"]
@{PRODUCT_XPATHS_REMOVE}    //*[@id="remove-sauce-labs-backpack"]    //*[@id="remove-sauce-labs-bike-light"]    //*[@id="remove-sauce-labs-bolt-t-shirt"]    //*[@id="remove-sauce-labs-fleece-jacket"]    //*[@id="remove-sauce-labs-onesie"]    //*[@id="remove-test.allthethings()-t-shirt-(red)"]
${empty_cart_message}    Your cart is empty
@{PRODUCT_XPATHS_PAYMENT}    //*[@id="checkout_summary_container"]/div/div[1]/div[3]/div[2]/div[2]/div    //*[@id="checkout_summary_container"]/div/div[1]/div[4]/div[2]/div[2]/div    //*[@id="checkout_summary_container"]/div/div[1]/div[5]/div[2]/div[2]/div    //*[@id="checkout_summary_container"]/div/div[1]/div[6]/div[2]/div[2]/div    //*[@id="checkout_summary_container"]/div/div[1]/div[7]/div[2]/div[2]/div    //*[@id="checkout_summary_container"]/div/div[1]/div[8]/div[2]/div[2]/div
${total_amount_selected}    0

*** Test Cases ***
Module4_1
    [Documentation]    Get Number Of Products In Cart
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Login To Website
    ${product_count}    Get Length    ${PRODUCT_XPATHS}
    Should Be Equal As Numbers    ${product_count}    6

Module4_2
    [Documentation]    Add Products to Cart and Verify quantiry in cart
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Login To Website
    FOR    ${index}    IN RANGE    0    ${PRODUCT_XPATHS.__len__()}
        ${product_xpath}    Set Variable    ${PRODUCT_XPATHS}[${index}]
        Click Element    ${product_xpath}
        Sleep    2s
        ${cart_count_before}    Get Text    //*[@id="shopping_cart_container"]/a/span
        ${cart_count_after}    Evaluate    ${cart_count_before} + 1    # Increase the number of products in the cart by 1
        ${new_product_xpath}    Set Variable    ${PRODUCT_XPATHS_REMOVE}[${index}]
        Run Keyword If    '${cart_count_before}' != '${cart_count_after}'    Log    Product added to cart successfully
    END

Module4_3
    [Documentation]    Remove products from the home page and verify that the cart count is updated accordingly.
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Login To Website
    Click Add to Cart Buttons
    ${cart_count_before_removal}    Get Text    ${cart_count_xpath}
    Log    Cart count before removal: ${cart_count_before_removal}
    Remove Products from Home
    Page Should Not Contain Element    ${cart_count_xpath}

Module4_4
    [Documentation]    Remove products from the cart by clicking on each product's remove button.
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Maximize Browser Window
    Login To Website
    Click Add to Cart Buttons
    Click Element    //*[@id="shopping_cart_container"]/a
    # Lặp qua danh sách các sản phẩm để xóa chúng khỏi giỏ hàng
    FOR    ${xpath}    IN    @{PRODUCT_XPATHS_REMOVE}
        Click Element    ${xpath}
    END
    Page Should Not Contain Element    ${cart_count_xpath}

Module4_5
    [Documentation]    Add each product to the cart by clicking on it.
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Maximize Browser Window
    Login To Website
    FOR    ${index}    IN RANGE    0    ${PRODUCT_XPATHS.__len__()}
        ${product_xpath}    Set Variable    ${PRODUCT_XPATHS}[${index}]
        Click Element    ${product_xpath}
        Sleep    2s
    END

Module4_6
    [Documentation]    Click on the cart icon to view the cart, then proceed to checkout.
    Click Element    ${cart_count_xpath}
    Click Element    xpath=//*[@id="checkout"]

Module4_7
    [Documentation]    Fill in the checkout form with the customer's information and proceed to the next step.
    Input Text    xpath=//*[@id="first-name"]    John
    Input Text    xpath=//*[@id="last-name"]    Doe
    Input Text    xpath=//*[@id="postal-code"]    12345
    Click Element    xpath=//*[@id="continue"]

Module4_8
    [Documentation]    Calculate and validate the total amount due during checkout.
    ${total_products_text}    Get Text    xpath=//*[@id="checkout_summary_container"]/div/div[2]/div[6]
    ${total_products}    Set Variable    ${total_products_text.split("$")[1]}
    # Lấy giá trị total products từ trang
    ${total_amount_selected}    Set Variable    0
    FOR    ${product_xpath_payment}    IN    @{PRODUCT_XPATHS_PAYMENT}
        ${product_price_text}    Get Text    ${product_xpath_payment}
        ${product_price}    Set Variable    ${product_price_text.split('$')[1].strip()}
        ${total_amount_selected}    Evaluate    ${total_amount_selected} + float(${product_price})
    END
    Should Be Equal As Numbers    ${total_products}    ${total_amount_selected}
    # Lấy giá trị thuế từ trang
    ${tax_amount_text}    Get Text    xpath=//*[@id="checkout_summary_container"]/div/div[2]/div[7]
    ${tax_amount}    Set Variable    ${tax_amount_text.split("$")[1]}
    # Tính toán giá trị dự kiến của thuế
    ${expected_tax_amount}    Evaluate    round(${total_amount_selected} * 0.08, 2)
    Should Be Equal As Numbers    ${tax_amount}    ${expected_tax_amount}
    ${total_amount_text}    Get Text    xpath=//*[@id="checkout_summary_container"]/div/div[2]/div[8]
    ${total_amount_due}    Set Variable    ${total_amount_text.split("$")[1]}
    # Calculate expected total amount including tax
    ${expected_total_with_tax}    Evaluate    float(${total_amount_selected}) + float(${tax_amount})
    # Làm tròn giá trị của ${expected_total_with_tax}
    ${expected_total_with_tax_rounded}    Evaluate    round(${expected_total_with_tax}, 2)
    Log    ${expected_total_with_tax_rounded}
    # Validate total amount due matches expected amount
    Should Be Equal As Numbers    ${total_amount_due}    ${expected_total_with_tax_rounded}

Module4_9
    [Documentation]    Complete the checkout process and verify the order confirmation message.
    Click Element    xpath=//*[@id="finish"]
    Page Should Contain    Thank you for your order!

Module4_10
    [Documentation]    Attempt to proceed to checkout without entering the first name and verify the error message.
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Maximize Browser Window
    Login To Website
    Click Element    xpath=//*[@id="shopping_cart_container"]/a
    Click Element    xpath=//*[@id="checkout"]
    Click Element    xpath=//*[@id="continue"]
    Page Should Contain    Error: First Name is required
    Close Browser

Module4_11
    [Documentation]    Attempt to proceed to checkout without entering the first name and verify the error message.
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Maximize Browser Window
    Login To Website
    Click Element    xpath=//*[@id="shopping_cart_container"]/a
    Click Element    xpath=//*[@id="checkout"]
    Input Text    xpath=//*[@id="last-name"]    Doe
    Input Text    xpath=//*[@id="postal-code"]    12345
    Click Element    xpath=//*[@id="continue"]
    Page Should Contain    Error: First Name is required
    Close Browser

Module4_12
    [Documentation]    Attempt to proceed to checkout without entering the last name and verify the error message.
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Maximize Browser Window
    Login To Website
    Click Element    xpath=//*[@id="shopping_cart_container"]/a
    Click Element    xpath=//*[@id="checkout"]
    Input Text    xpath=//*[@id="first-name"]    John
    Input Text    xpath=//*[@id="postal-code"]    12345
    Click Element    xpath=//*[@id="continue"]
    Page Should Contain    Error: Last Name is required
    Close Browser

Module4_13
    [Documentation]    Attempt to proceed to checkout without entering the postal code and verify the error message.
    Open Browser    ${URL}    ${BROWSER}
    Sleep    3s
    Maximize Browser Window
    Login To Website
    Click Element    xpath=//*[@id="shopping_cart_container"]/a
    Click Element    xpath=//*[@id="checkout"]
    Input Text    xpath=//*[@id="first-name"]    John
    Input Text    xpath=//*[@id="last-name"]    Doe
    Click Element    xpath=//*[@id="continue"]
    Page Should Contain    Error: Postal Code is required
    Close Browser

*** Keywords ***
Login To Website
    Input_text    ${username}    ${correct_username}
    Input_text    ${password}    ${correct_password}
    Click_element    ${button}

Click Add to Cart Buttons
    FOR    ${index}    IN RANGE    0    ${PRODUCT_XPATHS.__len__()}
        Click Element    ${PRODUCT_XPATHS}[${index}]
        Sleep    2s
    END

Remove Products from Home
    [Documentation]    Remove products from the cart
    FOR    ${index}    IN RANGE    0    ${PRODUCT_XPATHS_REMOVE.__len__()}
        ${product_xpath}    Set Variable    ${PRODUCT_XPATHS_REMOVE}[${index}]
        Click Element    ${product_xpath}
        Sleep    2s
    END
