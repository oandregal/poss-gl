#!/usr/bin/env python

import os
import sys
import math

ROOT = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(ROOT, '..'))

#http://code.google.com/intl/gl/apis/chart/
from pygooglechart import StackedHorizontalBarChart

import settings


def changeExtension(filename, ext):
      """ Returns a filename changing the actual extension by 'ext'. The 'filename' must have only one '.'. """
      aux = filename.split('.')
      return aux[0]+'.'+ext


def main(argv):

    nTraducidas = int(argv[0])
    nFuzzy = int(argv[1])
    nNoTraducidas = int(argv[2])

    totalCadenas = nTraducidas + nFuzzy + nNoTraducidas
    pTraducidas = (nTraducidas * 100) / totalCadenas
    pNoTraducidas = 100 - pTraducidas
    #print '% traducidos: ' + str(pTraducidas) + ' - % No Traducidos: ' + str(pNoTraducidas)

    chart = StackedHorizontalBarChart(settings.width,
                                      settings.height,
                                      x_range=(0, 100))
    # chart.set_bar_width(100)
    chart.set_colours(['00ff00', 'ff0000'])
    chart.fill_solid('bg', 'e3d185')
    chart.set_zero_line(0, 0)
    chart.add_data([pTraducidas])
    chart.add_data([pNoTraducidas])
    chart.download('../web/img/' +  changeExtension(argv[3], 'png'))

if __name__ == '__main__':
    main(sys.argv[1:])
