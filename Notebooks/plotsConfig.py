import numpy as np 
import matplotlib as mpl
mpl.use('TkAgg') # Or use: 'Qt4Agg'
import matplotlib.pyplot as plt

mpl.rc('lines', linewidth=2.0, markersize=5.0)
mpl.rcParams['axes.linewidth'] = 2
mpl.rcParams['legend.numpoints'] = 1
mpl.rcParams.update({'font.size': 18})
mpl.rcParams["font.family"] = "serif"
mpl.rcParams["mathtext.fontset"] = "dejavuserif"
marker = ['o', 's', 'd', '^', 'h', '*', '>', '<', '+'] ##-- Add more if needed
# cols = ['#477998', '#43aa8b', '#90be6d', '#f9c74f', '#f8961e', '#f94144']
cols = ['#001219', '#005f73', '#0a9396', '#94d2bd', '#ee9b00', '#ca6702', '#bb3e03', '#ae2012', '#9b2226']
cmap = plt.get_cmap('jet') #'nipy_spectral', 'gnuplot'
linestyles = [(0, (1, 5)), (0, (5, 5)), (0, (3, 5, 1, 5)), (0, (1, 1)), (0, (5, 1)), (0, (3, 1, 1, 1)), (0, (3, 5, 1, 5, 1, 5)), (0, (5, 10)), (0, (1, 10))]

# from matplotlib.colors import LinearSegmentedColormap
# #-- Col for ht field
# left_color = "#4cc9f0"   # Blue (low end)
# middle_color = "#000814" # White (middle)
# right_color = "#ffc300"  # Red (high end)
# colors = [left_color, middle_color, right_color]
# positions = [0.0, 0.25, 1.0]
# # cmap = LinearSegmentedColormap.from_list("custom_diverging", colors)
# cmap = LinearSegmentedColormap.from_list("custom_diverging", list(zip(positions, colors)))
