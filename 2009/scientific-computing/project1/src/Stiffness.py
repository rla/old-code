def constant_stiffness(x,y):
    "Constant coefficient S{lambda}(x,y)=1.0 for wave equation"
    return 1.0

def variable_stiffness(x,y):
    "Variable coefficient S{lambda}(x,y) for wave equation"
    if x>0.4 and x<0.7 and y<0.5:
        return .1
    else:
        return 1.0