#%%
import matplotlib.pyplot as plt
#%%
import numpy as np
#%%
def BPd(s,L,H,alpha):
    dist = alpha*L**(alpha)*s**(-alpha-1)/(1-(L/H)**alpha)
    return dist / np.sum(dist)
#%%
d = 50
s = np.array(range(d))+1
L = 1; H = d;
alphas = 10.**(-np.array(range(5)))#1/ (1+np.array(range(5)))**6
for alpha in alphas:
    plt.semilogy(s, BPd(s,L,H,alpha),label="alpha= %2.2e" % alpha)
plt.legend()
#%%
BPd(s[1:],L,H,1e-2)
#%%
from scipy.special import zeta
def zeta(s, lamb):
    lamb = lamb + 1
    dist = s**(-lamb)
    return dist / sum(dist)

#%%
lambs = np.array([1e-2, 1e-1, 1, 2])
fig,ax = plt.subplots()
for lamb in lambs:
    #ax.set_yscale('log')
    ax.scatter(s, zeta(s,lamb), label="lambda = %2.2f" % (lamb+1))
ax.legend()
#%%
