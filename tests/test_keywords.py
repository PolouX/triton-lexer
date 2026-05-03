def foo():
    pass

def bar(x):
    if x > 0:
        return True
    elif x == 0:
        return None
    else:
        return False

for i in range(10):
    if i is None:
        continue
    if not i:
        break

while True:
    pass

result = True and False
check = True or False
flag = not True
