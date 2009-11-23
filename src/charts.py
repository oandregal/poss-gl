#!/usr/bin/env python

import os
import sys
import math

ROOT = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(ROOT, '..'))

from pygooglechart import StackedHorizontalBarChart

import settings

def stacked_horizontal(chapter):
    chart = StackedHorizontalBarChart(settings.width,
                                      settings.height,
                                      x_range=(0, 100))
#     chart.set_bar_width(100)
    chart.set_colours(['00ff00', 'ff0000'])
    chart.set_zero_line(0, 0)
    chart.add_data([chapter[0]])
    chart.add_data([chapter[1]])
    chart.download('../web/img/'+chapter[2]+'.png')

def main():
    chapters = [
        [0, 100, 'book'],
        [100, 0, 'ch00'],
        [100, 0, 'ch01'],
        [71, 29, 'ch02'],
        [62, 38, 'ch03'],
        [0, 100, 'ch04'],
        [100, 0, 'ch05'],
        [0, 100, 'ch06'],
        [0, 100, 'ch07'],
        [0, 100, 'ch08'],
        [40, 60, 'ch09'],
        [0, 100, 'appa'],
        [0, 100, 'appb'],
        [0, 100, 'appc'],
        [0, 100, 'appd'],
        [0, 100, 'appe'],
        [0, 100, 'dedi']
        ]
    
    for i in range(len(chapters)):
        stacked_horizontal(chapters[i])

if __name__ == '__main__':
    main()

