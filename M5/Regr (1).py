#!/usr/bin/env python
# coding: utf-8

# In[1]:


"Regresjons analyse av Skattetall Oslo 2020"
"Hentet ut fra vg"


# In[2]:


from bs4 import BeautifulSoup
import requests
import numpy as np


# In[3]:


def fetch_html_tables(url):
    "Returns a list of tables in the html of url"
    page = requests.get(url)
    bs=BeautifulSoup(page.content)
    tables=bs.find_all('table')
    return tables

tables=fetch_html_tables('https://www.vg.no/spesial/skattelister/2020/0301/')
table_html=tables[0]

#printing top
print(str(table_html)[:1000])


# In[4]:


def html_to_table(html):
    "Returns the table defined in html as a list"
    #defining the table:
    table=[]
    #iterating over all rows
    for row in html.find_all('tr'):
        r=[]
        #finding all cells in each row:
        cells=row.find_all('td')
        
        #if no cells are found, look for headings
        if len(cells)==0:
            cells=row.find_all('th')
            
        #iterate over cells:
        for cell in cells:
            cell=format(cell)
            r.append(cell)
        
        #append the row to t:
        table.append(r)
    return table

def format(cell):
    "Returns a string after converting bs4 object cell to clean text"
    if cell.content is None:
        s=cell.text
    elif len(cell.content)==0:
        return ''
    else:
        s=' '.join([str(c) for c in cell.content])
        
    #here you can add additional characters/strings you want to 
    #remove, change punctuations or format the string in other
    #ways:
    s=s.replace('\xa0',"")
    s=s.replace('\n',"")
    s=s.replace("\ue5cf","")
    return s

table=html_to_table(table_html)

#printing top
print(str(table)[:1000])


# In[5]:


';'.join(table[0])


# In[ ]:





# In[6]:


def save_data(file_name,table):
    "Saves table to file_name"
    f=open(file_name,'w')
    for row in table:
        f.write(';'.join(row)+'\n')
    f.close()
    
save_data('Skatteliste_oslo.csv',table)


# In[7]:


import pandas as pd
oslo = pd.read_csv('Skatteliste_oslo.csv', delimiter=';', encoding='utf8')

oslo


# In[17]:


import numpy as np
from matplotlib import pyplot as plt

fig,ax=plt.subplots()

#adding axis lables:
ax.set_ylabel('Inntekt')
ax.set_xlabel('Skatt')

#plotting the function:
ax.scatter(oslo['Skatt'], oslo['Inntekt'],  label='Observasjoner')
ax.legend(loc='lower right',frameon=False)


# In[9]:


y=oslo['Skatt']
pd.DataFrame(y)


# In[10]:



x=pd.DataFrame((oslo['Skatt']))
x['Intercept']=1
x


# In[11]:


from statsmodels.regression.linear_model import OLS

res=OLS(y,x).fit()

print(res.summary())


# In[12]:


res.params


# In[ ]:





# In[16]:


x=np.linspace(min((oslo['Skatt'])), max((oslo['Inntekt'])), 100)

regression_line=res.params['Intercept']+res.params['Skatt']*x

ax.plot(x, regression_line,color='red',label="Regression line")
fig


# In[18]:


"Vi ser at regresjonslinjen ikke passer i plotten. Regresjon linja og antall observasjoner som holder seg nærme linja vil si at det er sterk korrelasjon"
"Her ser vi at det ikke er en korrelasjon"


"Sammarbeidet med Adrian Risberg, Andre Ydstebø, Mathias Hetland" 
"Det meste av koden som er brukt/inspirert er fra Espen Sirnes"
"Litt usikker på hva som skjedde med regresjon linja mi"

