# Python 3.8.5

from string import printable

node = []
for c in printable: node.append(c)

edge = {'X': ['5', '5'], '5': ['O', '4'], 'O': ['!'], '!': ['P', '$'], 'P': ['%', '[', 'Z', '^'], '%': ['@'], '@': ['A'], 'A': ['P', 'R', 'N', 'R', 'N'], '[': ['4'], '4': ['\\', '('], '\\': ['P'], 'Z': ['X'], '(': ['P'], '^': [')'], ')': ['7', '7'], '7': ['C', '}'], 'C': ['C', ')', 'A'], '}': ['$'], '$': ['E', 'H'], 'E': ['I', 'S', '!'], 'I': ['C', 'V', 'R', 'L'], 'R': ['-', 'D', 'U'], '-': ['S', 'A', 'T', 'F'], 'S': ['T', '-', 'T'], 'T': ['A', 'I', 'E', '-'], 'N': ['D', 'T'], 'D': ['A', '-'], 'V': ['I'], 'U': ['S'], 'F': ['I'], 'L': ['E'], 'H': ['+', '*'], '+': ['H'], '*': []}

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
        open('output.txt', 'r') ## this would trigger most Anti-virus programs, or the previous line would.
        return None
    dfs_with_switch(edge[node][curr_sw], switch, output_file)

dfs_with_switch('A')
dfs_with_switch('X')

