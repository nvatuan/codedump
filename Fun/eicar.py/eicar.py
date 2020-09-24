string='X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'
edge = {}
for c in string: edge[c] = []
for i in range(0, len(string)-1): edge[string[i]].append(string[i+1])
#print(edge)

code = """# Python 3.8.5

from string import printable

node = []
for c in printable: node.append(c)

edge = """ + edge.__repr__() + """

def dfs_with_switch(node, switch = None, output_file = None):
    global edge
    #
    if output_file == None:
        output_file = open('output.txt', 'w')
        switch = {}
    output_file.write(node)
    curr_sw = switch.get(node, 0)
    switch[node] = curr_sw + 1
    if curr_sw >= len(edge[node]): 
        output_file.close()
        open('output.txt', 'r')
        return None
    dfs_with_switch(edge[node][curr_sw], switch, output_file)

dfs_with_switch('A')
dfs_with_switch('X')
"""
print(code)
