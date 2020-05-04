from math import pi, sqrt #Needed to calculate the area of a circle later on

class Shape(object):
    """
    This superclass defines a usual shape, that can be further divided into different categories.
    As shape is only defined by its name, since its sides are defined in the children classes as they depend on the shape considered.
    """
    def __init__(self, name = 'Shape'):
        """Initializer of the Shape superclass, taking only a string for the name of the shape as argument."""
        self.name = name
 
    def __str__(self):
        """Self description for print() and str() of the superclass Shape"""
        return '{}'.format(self.name)
 
    def __repr__(self):
        """Representative description for repr() of the superclass Shape"""
        return self.__str__()  #The shape only has a name, so in this case it makes for __str__ and __repr__ to give back the same string
 
    def get_area(self):
        raise NotImplementedError #Not implemented in the superclass
        
    def __add__(self):
        raise NotImplementedError #Not implemented in the superclass
        
    def __sub__(self):
        raise NotImplementedError #Not implemented in the superclass
        
    def __mul__(self):
        raise NotImplementedError #Not implemented in the superclass
        
    def __truediv__(self): #Python 3 definition
        raise NotImplementedError #Not implemented in the superclass

    def __gt__(self, other): 
        """Is one shape greater than another shape based on the area?"""
        return self.get_area() > other.get_area()
    
    def __lt__(self, other):
        """Is one shape smaller than another shape based on the area?"""
        return self.get_area() < other.get_area()
    
    def __eq__(self):
        raise NotImplementedError #Not implemented in the superclass

class Circle(Shape):
    """Specific shape called Circle, defined from a radius given as an integer or a float. A ValueError is raised if a circle with a negative radius is created."""
    def __init__(self, radius = 1.0, name = 'Circle'):
        """Initializer"""
        if radius >= 0:
            super().__init__(name)  # Call superclass' initializer
            self.radius = radius
        else:
            raise ValueError('The radius of a circle should be positive.') #The radius should be positive
 
    def __str__(self):
        """Self description for print() and str()"""
        return 'This is a shape called {}, having a radius of {} and an area equal to {}.'.format(self.name, self.radius, self.get_area())
 
    def __repr__(self):
        """Representative description for repr()"""
        return 'Shape({}, radius={})'.format(super().__str__(), self.radius) #Let's call the parent __str__ representation to get the name of the shape
 
    def get_area(self):
        """Returns the area of the circle rounded to 2 decimals."""
        return str(round(self.radius * self.radius * pi, 2)) #Round to two decimals should be enough
    
    def __add__(self, other): #Addition of two circles is equivalent to summing the radii
        """Allows to add two circles together or an integer to a circle (in this case, we create a new circle having a radius equal to the previous radius plus the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to the radius
        if type(other) == int:
            newRadius = self.radius + other
        #Else, if we are adding two circles
        else:
            newRadius = self.radius + other.radius
        return Circle(newRadius)
    
    def __sub__(self, other): #Addition of two circles is equivalent to summing the radii
        """Allows to substract two circles together or an integer to a circle (in this case, we create a new circle having a radius equal to the previous radius minus the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to the radius
        if type(other) == int:
            newRadius = self.radius - other
        #Else, if we are adding two circles
        else:
            newRadius = self.radius - other.radius
        return Circle(newRadius)
    
    def __mul__(self, other): #Addition of two circles is equivalent to summing the radii
        """Allows to multiply two circles together or an integer to a circle (in this case, we create a new circle having a radius equal to the previous radius multiplied by the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to the radius
        if type(other) == int:
            newRadius = self.radius * other
        #Else, if we are adding two circles
        else:
            newRadius = self.radius * other.radius
        return Circle(newRadius)
    
    def __truediv__(self, other): #Addition of two circles is equivalent to summing the radii
        """Allows to divide two circles together or an integer to a circle (in this case, we create a new circle having a radius equal to the previous radius divided by the integer given). A circle of radius 0 is given back in case the division does not work."""
        #First let's check if other is a number because if it is, then we just need to add this number to the radius
        if type(other) == int and other != 0:
            newRadius = self.radius / other
        #Else, if we are adding two circles
        elif other.radius != 0:
            newRadius = round(self.radius / other.radius) #Rounded to two decimals
        else:
            newRadius = 0
        return Circle(newRadius)
    
    def __eq__(self, other):
        """Are two circles equal based on their radius?"""
        return self.radius == other.radius #They are if they have the same radius
 
class Rectangle(Shape):
    """Specific shape called Circle, defined from its width and length given as integers or floats. A ValueError is raised if a negative width or length is given."""
    def __init__(self, length = 1.0, width = 1.0, name = 'Rectangle'):
        """Initializer"""
        super().__init__(name)
        if length >= 0 and width >= 0:
            self.length = length
            self.width = width
        else:
            raise ValueError('The width and the length of a rectangle should be positive.')
 
    def __str__(self):
        """Self description for print() and str()"""
        return 'This is a shape called {}, having a width of {}, a length of {} and an area equal to {}.'.format(self.name, self.width, self.length, self.get_area())
 
    def __repr__(self):
        """Representative description for repr()"""
        return 'Shape({}, length={}, width={})'.format(super().__str__(), self.length, self.width)
 
    def get_area(self):
        """Returns the area of the rectangle rounded to 2 decimals."""
        return str(round(self.length * self.width, 2)) #Round to two decimals should be enough
    
    def __add__(self, other):
        """Allows to add two rectangles together or an integer to a rectangle (in this case, we create a new rectangle having a width and length equal to the previous width and length plus the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to the width and length
        if type(other) == int:
            newWidth = self.width + other
            newLength = self.length + other
        #Else, if we are adding two rectangles
        else:
            newWidth = self.width + other.width
            newLength = self.length + other.length
        return Rectangle(newLength, newWidth)
    
    def __sub__(self, other):
        """Allows to substract two rectangles together or an integer to a rectangle (in this case, we create a new rectangle having a width and length equal to the previous width and length minus the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to the width and length
        if type(other) == int:
            newWidth = self.width - other
            newLength = self.length - other
        #Else, if we are adding two rectangles
        else:
            newWidth = self.width - other.width
            newLength = self.length - other.length
        return Rectangle(newLength, newWidth)

    def __mul__(self, other):
        """Allows to multiply two rectangles together or an integer to a rectangle (in this case, we create a new rectangle having a width and length equal to the previous width and length multiplied by the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to the width and length
        if type(other) == int:
            newWidth = self.width * other
            newLength = self.length * other
        #Else, if we are adding two rectangles
        else:
            newWidth = self.width * other.width
            newLength = self.length * other.length
        return Rectangle(newLength, newWidth)
    
    def __truediv__(self, other):
        """Allows to divide two rectangles together or an integer to a rectangle (in this case, we create a new rectangle having a width and length equal to the previous width and length divided by the integer given). A rectangle of length and width 0 is given back in case the division does not work."""
        #First let's check if other is a number because if it is, then we just need to add this number to the width and length
        if type(other) == int and other != 0:
            newWidth = self.width / other
            newLength = self.length / other
        #Else, if we are adding two rectangles
        elif other.width != 0 and other.length != 0:
            newWidth = round(self.width / other.width, 2)
            newLength = round(self.length / other.length, 2)
        else:
            newWidth = 0
            newLength = 0
        return Rectangle(newLength, newWidth)
    
    def __eq__(self, other):
        """Are two rectangles equal based on their widths and lengths? (rotated rectangles are considered to be equal)"""
        output = (self.width == other.width and self.length == other.length) or (self.width == other.length and self.length == other.width)
        return output #They are if they have the same width and length, or if the width of one is equal to the length of the other and vice versa (rotated rectangles)
    
class Triangle(Shape):
    """Specific shape called Triangle, defined from its three sides given as integers or floats. A ValueError is raised if any of the three sides given is negative."""
    def __init__(self, side1 = 1.0, side2 = 1.0, side3 = 1.0, name = 'Triangle'):
        """Initializer"""
        super().__init__(name)
        if side1 >= 0 and side2 >= 0 and side3 >= 0:
            self.sides = [side1, side2, side3]
        else:
            raise ValueError('The three sides of a triangle should all be positive.')
 
    def __str__(self):
        """Self description for print() and str()"""
        return 'This is a shape called {}, having a the sides {} and an area equal to {}.'.format(self.name, self.sides, self.get_area())
 
    def __repr__(self):
        """Representative description for repr()"""
        return 'Shape({}, sides={})'.format(super().__str__(), self.sides)
 
    def get_area(self): #Calulcated using Heron's formula [2]
        """Returns the area of the triangle rounded to 2 decimals."""
        semiPerimeter = sum(self.sides)/2 
        area = sqrt(semiPerimeter*(semiPerimeter-self.sides[0])*(semiPerimeter-self.sides[1])*(semiPerimeter-self.sides[2]))
        return str(round(area, 2)) #Round to two decimals should be enough
    
    def __add__(self, other):
        """Allows to add two triangles together or an integer to a triangle (in this case, we create a new triangle having its sides equal to the previous sides lengths plus the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to all the sides
        if type(other) == int:
            newSides = [x + other for x in self.sides]
        #Else, if we are adding two triangles
        else:
            newSides = [sum(x) for x in zip(self.sides, other.sides)]
        return Triangle(newSides[0], newSides[1], newSides[2])
    
    def __sub__(self, other):
        """Allows to substract two triangles together or an integer to a triangle (in this case, we create a new triangle having its sides equal to the previous sides lengths minus the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to all the sides
        if type(other) == int:
            newSides = [x - other for x in self.sides]
        #Else, if we are adding two triangles
        else:
            newSides = [x1-x2 for (x1, x2) in zip(self.sides, other.sides)]
        return Triangle(newSides[0], newSides[1], newSides[2])
    
    def __mul__(self, other):
        """Allows to multiply two triangles together or an integer to a triangle (in this case, we create a new triangle having its sides equal to the previous sides lengths multiplied by the integer given)"""
        #First let's check if other is a number because if it is, then we just need to add this number to all the sides
        if type(other) == int:
            newSides = [x * other for x in self.sides]
        #Else, if we are adding two triangles
        else:
            newSides = [x1*x2 for (x1, x2) in zip(self.sides, other.sides)]
        return Triangle(newSides[0], newSides[1], newSides[2])
    
    def __truediv__(self, other):
        """Allows to divide two triangles together or an integer to a triangle (in this case, we create a new triangle having its sides equal to the previous sides lengths divided by the integer given). A triangle of sides 0 is given back in case the division does not work."""
        #First let's check if other is a number because if it is, then we just need to add this number to all the sides
        if type(other) == int and other != 0:
            newSides = [x / other for x in self.sides]
        #Else, if we are adding two triangles
        elif type(other) != int and 0 not in other.sides:
            newSides = [round(x1/x2, 2) for (x1, x2) in zip(self.sides, other.sides)]
        else: #Division by zero
            newSides = [0,0,0]
        return Triangle(newSides[0], newSides[1], newSides[2])

    def __eq__(self, other):
        """Are two triangles equal based on their three sides (rotated triangles are considered to be equal)?"""
        output =  True
        return set(self.sides) == set(other.sides) #They are if they have the same three sides, no matter the order of the elements in the sides list (rotated triangles)

#Now starting to test the different classes and methods implemented
if __name__ == '__main__':
    
    #Let's first try to create different objects
    print("================ SHAPE ================")
    s1 = Shape()
    print(s1) #Not really useful at this stage, but will be for the subclasses
    #print(s1.get_area()) #Raises a NotImplementedError if not commented, as expected
    
    print("\n================ CIRCLE ================")
    c1 = Circle() #By default, its radius should be equal to 1.0
    c2 = Circle(2.0)
    c3 = Circle(2.0)
    #c4 = Circle(-1.0) #Attempt to create a negative circle is going to raise a ValueError
    
    print(str(c1)) 
    print("c1 = " + repr(c1)) 
    print(str(c2))
    print("c2 = " + repr(c2)) 
    print(str(c3))
    print("c3 = " + repr(c3)) 
    
    print("---> Is c1 larger than c2? " + str(c1 > c2))
    print("---> Is c1 smaller than c2? " + str(c1 < c2))
    print("---> Is c1 equal to c2? " + str(c1 == c2))
    print("---> Is c2 equal to c3? " + str(c2 == c3))
    print("\n================ RECTANGLE ================")
    r1 = Rectangle() #By default, its width and length should be equal to 1.0
    r2 = Rectangle(2.0, 3.0)
    r3 = Rectangle(3.0, 2.0)
    
    print(str(r1))   
    print("r1 = " + repr(r1))   
    print(str(r2))   
    print("r2 = " + repr(r2))
    print(str(r3))   
    print("r3 = " + repr(r3))
    
    print("---> Is r1 larger than r2? " + str(r1 > r2))
    print("---> Is r1 smaller than r2? " + str(r1 < r2))
    print("---> Is r1 equal to r2? " + str(r1 == r2))
    print("---> Is r2 equal to r3? " + str(r2 == r3))
    print("\n================ TRIANGLE ================")
    t1 = Triangle() #By default, its three sides should be equal to 1.0
    t2 = Triangle(3.0, 4.0, 5.0)
    t3 = Triangle(5.0, 3.0, 4.0)
    print(str(t1))   
    print("t1 = " + repr(t1))   
    print(str(t2))   
    print("t2 = " + repr(t2))
    print(str(t3))   
    print("t3 = " + repr(t3))
    
    print("---> Is t1 larger than t2? " + str(t1 > t2))
    print("---> Is t1 smaller than t2? " + str(t1 < t2))
    print("---> Is t1 equal to t2? " + str(t1 == t2))
    print("---> Is t2 equal to t3? " + str(t2 == t3))
    
    #Let's now try to add integers to the different objects and objects of the same class with each other
    print("\n================ ADDITION ================")
    print("The sum of c1 and c2 is a " + repr(c1 + c2))
    print("The sum of c1 and the integer 4 is a " + repr(c1 + 4))
    #print("Attempt to create a negative radius circle " + repr(c1 - 4)) #This raises a ValueError
    print("The sum of r1 and r2 is a " + repr(r1 + r2))
    print("The sum of r1 and the integer 4 is a " + repr(r1 + 4))
    print("The sum of t1 and t2 is a " + repr(t1 + t2))
    print("The sum of t1 and the integer 4 is a " + repr(t1 + 4))
    
    print("\n================ SUBSTRACTION ================")
    print("The substraction of c2 and c1 is a " + repr(c2 - c1))
    print("The substraction of c2 and the integer 1 is a " + repr(c2 - 1))
    print("The substraction of r2 and r1 is a " + repr(r2 - r1))
    print("The substraction of r2 and the integer 1 is a " + repr(r2 - 1))
    print("The substraction of t2 and t1 is a " + repr(t2 - t1))
    print("The substraction of t2 and the integer 1 is a " + repr(t2 - 1))
    
    print("\n================ MULTIPLICATION ================")
    print("The multiplication of c1 and c2 is a " + repr(c1 * c2))
    print("The multiplication of c1 and the integer 4 is a " + repr(c1 * 4))
    print("The multiplication of r1 and r2 is a " + repr(r1 * r2))
    print("The multiplication of r1 and the integer 4 is a " + repr(r1 * 4))
    print("The multiplication of t1 and t2 is a " + repr(t1 * t2))
    print("The multiplication of t1 and the integer 4 is a " + repr(t1 * 4))
    
    print("\n================ DIVISION ================")
    print("The division of c1 and c2 is a " + repr(c1 / c2))
    print("The division of c1 and the integer 4 is a " + repr(c1 / 4))
    print("The division of r1 and r2 is a " + repr(r1 / r2))
    print("The division of r1 and the integer 4 is a " + repr(r1 / 4))
    print("The division of t1 and t2 is a " + repr(t1 / t2))
    print("The division of t1 and the integer 4 is a " + repr(t1 / 4))
    print("Attempt of vision by zero " + repr(t1 / 0))
