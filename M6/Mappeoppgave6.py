#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Kode hentet fra espen sirnes


# In[2]:


from bs4 import BeautifulSoup
import requests

def fetch_html_tables(url):
    "Returns a list of tables in the html of url"
    page = requests.get(url)
    bs=BeautifulSoup(page.content)
    tables=bs.find_all('table')
    return tables

tables=fetch_html_tables('https://www.macrotrends.net/countries/ranking/gdp-gross-domestic-product')
table_html=tables[0]

#printing top
print(str(table_html)[:1000])


# In[3]:


def html_to_table(html):
    "Returns the table defined in html as a list"
    #defining the table:
    table=[]
   
    for row in html.find_all('tr'):
        r=[]
   
        cells=row.find_all('td')
        
      
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
    s=s.replace('\xa0','')
    s=s.replace('\n','')
    return s

table=html_to_table(table_html)

#printing top
print(str(table)[:1000])


# In[4]:


';'.join(table[0])


# In[5]:


def save_data(file_name,table):
    "Saves table to file_name"
    f=open(file_name,'w')
    for row in table:
        f.write(';'.join(row)+'\n')
    f.close()
    
save_data('GDP_BY_Country.csv',table)


# In[ ]:





# In[6]:


import pandas as pd
GDP=pd.read_csv('GDP_BY_Country.csv', delimiter=';', encoding='utf8')
GDP


# In[7]:


GDP.rename(columns = {'Country Name':'Land'}, inplace = True)
GDP


# In[8]:


GDP['2018'].replace(',','', regex=True, inplace=True)
GDP['2017'].replace(',','', regex=True, inplace=True)
GDP['2016'].replace(',','', regex=True, inplace=True)
GDP['2015'].replace(',','', regex=True, inplace=True)
GDP['2014'].replace(',','', regex=True, inplace=True)
GDP

#Tar vekk unødige variabler 


# In[9]:



for i in range(len(GDP['2018'])):
    GDP['2018'][i]=GDP['2018'][i][1:]
    
for i in range(len(GDP['2017'])):
    GDP['2017'][i]=GDP['2017'][i][1:]
    
for i in range(len(GDP['2016'])):
    GDP['2016'][i]=GDP['2016'][i][1:]
    
for i in range(len(GDP['2015'])):
    GDP['2015'][i]=GDP['2015'][i][1:]
    
for i in range(len(GDP['2014'])):
    GDP['2014'][i]=GDP['2014'][i][1:]

GDP

#Fjerner Dollar tegnet slik at jeg kan omgjøre den til numeric


# In[10]:


GDP['2018'] = GDP['2018'].apply(pd.to_numeric,errors='coerce')
GDP['2014'] = GDP['2014'].apply(pd.to_numeric,errors='coerce')
GDP

#Gjør om tallene til numeric slik at jeg kan putte dem inn i matplot


# In[11]:


from matplotlib import pyplot as plt

fig,ax=plt.subplots()

ax.set_ylabel('2014')
ax.set_xlabel('2018')

ax.scatter(GDP['2018'], GDP['2014'],  label='GDP')
ax.legend(loc='lower right',frameon=False)


# In[12]:


import numpy as np
from matplotlib import pyplot as plt

fig,ax=plt.subplots()

#adding axis lables:
ax.set_ylabel('2014')
ax.set_xlabel('2018')

#plotting the function:
ax.scatter(np.log(GDP['2014']), GDP['2018'],  label='GDP per land')
ax.legend(loc='lower right',frameon=False)


# In[13]:





# In[14]:


'{:,}'.format(int(23153161365)).replace(',',' ')


# In[19]:


from bokeh.plotting import figure

#creating figure:
p = figure(
        title = "Endring av GDP fra 2014 til 2018", 
        x_axis_label = 'GDP 2018',
        y_axis_label = 'GDP 2014',
    
    
    
        tools="hover", 
        tooltips = [
            ("Land","@Land"),
            ("GDP","2018,@2018"),
            ("GDP","2014,@2014")
            ],
    
        plot_height = 580,
        plot_width = 980)


# In[20]:


from bokeh.io import show, output_notebook
from bokeh.plotting import output_file

p.scatter(
    source=GDP,
    x= '2018', 
    y= '2014',
    
    size='50', 
    color= 'Green',
    alpha= 0.8
    )

#Creating the graph and saving as html
output_notebook()
output_file("GDP_Verden.html")
show(p)


# In[ ]:





# In[17]:


#Kilder:

#https://www.macrotrends.net/countries/ranking/gdp-gross-domestic-product
#https://stackoverflow.com/questions/8270092/remove-all-whitespace-in-a-string
#https://stackoverflow.com/questions/36225517/pandas-how-to-edit-values-in-a-column
#https://stackoverflow.com/questions/39721559/applypd-to-numeric-returns-error-message
#https://stackoverflow.com/questions/38516481/trying-to-remove-commas-and-dollars-signs-with-pandas-in-python
#https://stackoverflow.com/questions/64636018/error-in-due-loop-of-ufunc-does-not-support-argument-0-of-type-str-which-has-no
#https://stackoverflow.com/questions/18434208/pandas-converting-to-numeric-creating-nans-when-necessary


# In[ ]:




