#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 27 20:43:59 2023

@author: zhangjiaxuan
"""

import numpy as np
import matplotlib.pyplot as plt

def calc_next_step_noise(Vm, I, step_t, remaining_refrac_time,sigma):
    Vl = -70
    Gl = 0.025
    C = 1
    g = Gl/C
    mu = (Gl*Vl + I)/C
    wn = np.random.normal()
    if Vm > -50 and Vm < 0: 
        Vm = 30 #spike potential
    elif Vm > 0:
        Vm = -60 #reset potential
        remaining_refrac_time = remaining_refrac_time*0 + 2 
    elif remaining_refrac_time>0:
        Vm = -60 #reset potential
        remaining_refrac_time -= step_t
    else:
        Vm = Vm + step_t*(-g*Vm + mu) + sigma*np.sqrt(step_t)*wn
    if remaining_refrac_time<0:
        remaining_refrac_time = remaining_refrac_time*0
    return Vm,remaining_refrac_time

step_t = 0.001
t = np.arange(0,500+step_t,step_t)
Vm_out = np.zeros(np.shape(t)[0])
I = 1.25
sigma=1
ind = 0
Vm_out[0]=-70 #init state
remaining_refrac_time = 0
aa=np.arange(0,100,1)
print(aa)
mean_isi = np.zeros(100) 
std_isi = np.zeros(100) 
for j in aa:
    ind = 0
    for tt in t[0:-1]:
        Vm_out[ind+1],remaining_refrac_time = calc_next_step_noise(Vm_out[ind], I, step_t, remaining_refrac_time,sigma)
        ind += 1
    v = Vm_out
    vol = np.zeros((2,len(v)))
    vol[0]=v
    vol[1]=t

    for ii in np.arange(0,np.shape(vol)[0]-1,1):
        b=np.argwhere(vol[ii,:]==30)
        a=idx_spike = np.transpose(b)
        idx_spike_diff = np.diff(idx_spike)*step_t
        mean_isi[j] = np.mean(idx_spike_diff)
        print(mean_isi[j])
        std_isi[j] = np.std(idx_spike_diff)


plt.scatter(aa,mean_isi)
plt.scatter(aa,std_isi)
plt.axhline(13)
plt.axhline(3.5)
plt.xlabel("time")
plt.ylabel("mean/std")
plt.show()
