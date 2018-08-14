When concatinating single quote string using `|` operator like this:  

`[ ​'cat' ​ | ​'dog' ​ ]`

The result list's first element is a whole element which is the `'cat'` string, and also a list.  And the other elements are single element in original list before concatenation, which means the code point of each char in `'dog'`.  

Hence, when printed in IEX, the first element is printed as a whole, which the remaining elements are printed individually.  
