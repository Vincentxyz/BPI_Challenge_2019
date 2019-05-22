from sklearn.datasets import load_iris
from sklearn import tree
from sklearn import datasets
from sklearn.tree import _tree
import pandas as pd

import os
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz2.38/bin'

# Load iris
iris = datasets.load_iris()
X = iris.data
y = iris.target

# Build decision tree classifier
dt = tree.DecisionTreeClassifier(criterion='entropy')
dt.fit(X, y)

import graphviz
dot_data = tree.export_graphviz(dt, out_file=None)
graph = graphviz.Source(dot_data)
graph.render("iris")

# COPY FROM THIS POINT DOWN TO THE END AND PASTE IT TO YOUR OWN PYTHON CLASSIFIER FILE

# Modified from these sources:
# https://gist.github.com/eherrerosj/ed3400b06f3c5c7668c62653e2a695c2
# https://www.kdnuggets.com/2017/05/simplifying-decision-tree-interpretation-decision-rules-python.html

# The two functions below are functionally the same, only differ in printing style

from sklearn.tree import _tree # IMPORTANT: _tree, NOT tree

def tree_to_code(tree, feature_names): # tree: DecisionTreeClassifier, feature_names: list of feature names
    tree_ = tree.tree_
    feature_name = [
        feature_names[i] if i != _tree.TREE_UNDEFINED else "undefined!"
        for i in tree_.feature
    ]
    print ("def tree({}):".format(", ".join(feature_names)))

    def recurse(node, depth):
        indent = "  " * depth
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            name = feature_name[node]
            threshold = tree_.threshold[node]
            print ("{}if {} <= {}:".format(indent, name, threshold))
            recurse(tree_.children_left[node], depth + 1)
            print ("{}else:  # if {} > {}".format(indent, name, threshold))
            recurse(tree_.children_right[node], depth + 1)
        else:
            print("{}return {}".format(indent, tree_.value[node]))

    recurse(0, 1)
    

    
def tree_to_table(tree, feature_names): # tree: DecisionTreeClassifier, feature_names: list of feature names
    features_with_values = pd.DataFrame(columns=['feature','value'])
    tree_ = tree.tree_
    feature_name = [
        feature_names[i] if i != _tree.TREE_UNDEFINED else "undefined!"
        for i in tree_.feature
    ]

    def recurse(node, depth, features_with_values):
        
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            name = feature_name[node]
            threshold = tree_.threshold[node]
            features_with_values = features_with_values.append({'feature' : name, 'value' : threshold}, ignore_index= True)
            features_with_values = features_with_values.append(recurse(tree_.children_left[node], depth + 1, features_with_values))
            features_with_values = features_with_values.append({'feature' : name, 'value' : threshold}, ignore_index= True)
            features_with_values = features_with_values.append(recurse(tree_.children_right[node], depth + 1, features_with_values))
            
            return features_with_values

    features_with_values = recurse(0, 1, features_with_values).drop_duplicates()
    
    features_with_values.sort_values(['feature', 'value'])
    
    return features_with_values


def tree_to_code_with_brackets(tree, feature_names):
    '''
    Outputs a decision tree model as if/then pseudocode

    Parameters:
    -----------
    tree: decision tree model
        The decision tree to represent as pseudocode
    feature_names: list
        The feature names of the dataset used for building the decision tree
    '''

    left = tree.tree_.children_left
    right = tree.tree_.children_right
    threshold = tree.tree_.threshold
    features = [feature_names[i] for i in tree.tree_.feature]
    value = tree.tree_.value

    def recurse(left, right, threshold, features, node, depth=0):
        indent = "  " * depth
        if (threshold[node] != -2):
            print(indent, "if ( " + features[node] + " <= " + str(threshold[node]) + " ) {")
            if left[node] != -1:
                recurse(left, right, threshold, features, left[node], depth + 1)
                print(indent, "} else {")
                if right[node] != -1:
                    recurse(left, right, threshold, features, right[node], depth + 1)
                print(indent, "}")
        else:
            print(indent, "return " + str(value[node]))

    recurse(left, right, threshold, features, 0)


#tree_to_code(dt, list(iris.feature_names))
#tree_to_code_with_brackets(dt, list(iris.feature_names))