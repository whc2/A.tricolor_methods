#get_go_term.py 
import sys 
raw_file = open(sys.argv[1]).read()  
with open("go_term.list","w") as output:
     for go_term in raw_file.split("[Term]"):
         go_id = ''
         name = '' 
         namespace = ''
         for line in go_term.split("\n"):
             if str(line).startswith("id") and "GO:" in line:
                 go_id = line.rstrip().split(" ")[1]
             if str(line).startswith("name:"):
                 name = line.rstrip().split(": ")[1]
             if str(line).startswith("namespace"):
                 namespace = line.rstrip().split(" ")[1]
         term = go_id + '\t' + name + '\t' + namespace + '\n'
         if '' != go_id:
             output.write(term)
