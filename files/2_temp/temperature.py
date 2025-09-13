print('hello')

# defining a function
def my_converter(c:float):
    '''
        In this part of the function you can describe the inputs and what the function does.
        "my_converter" is the name of the function.
        In brackets are the expected inputs (or arguments)
        We can specify the expected data types by adding a colon after the input variable name¨
        All inputs to the function should be used within the function - if they are not, there is no need for them
        We can generate additional variables within the function, these should be used again within the function (e.g. as the final outpt)
    '''
    fahrenheit = c * 9/5 + 32
    return fahrenheit


## ways of applying this function

# none of these options will display the result in the terminal upon running as noting is being printed
my_converter(17)
x=15
my_converter(x)
result = my_converter(x)

# only these three results will be printed
print(my_converter(17))
print(my_converter(x))
print(result)

# more elaborate printing
c = 32
print(c, "degrees celsius is equal to", my_converter(c), "degrees fahrenheit")
print(f"{c} degrees celsius is equal to {my_converter(c)} degrees fahrenheit")



# making the function a bit fancier

def c_to_f(celsius):
    '''
    This function takes degrees celsius as an input 
    '''
    if not isinstance(celsius, (float, int)):
        raise ValueError("Input should be a number")
    else:
        fahrenehit = celsius * 9/5 + 32
        return fahrenehit

