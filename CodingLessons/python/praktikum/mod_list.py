
import ex44

# print all names exported by the module(my written python file ex44.py)
print(dir(ex44))

#define variable "student2" to imported module "ex44" and it's class "student"
student2=ex44.student()

#print "student2" variable, named by class "student" and it's object "course4", 
# defined by digit "4" in file "ex44.py"
print(f"Student 1 studies on {student2.course4} course")
