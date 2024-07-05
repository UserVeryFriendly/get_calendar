import pandas as pd
import datetime
from io import StringIO
import csv


def get_csv(year, token):
    url = f"https://production-calendar.ru/get-period/{token}/ru/{year}/csv"
    
    skiprows = list(range(0, 8))
    skipfooter = 6

    df = pd.read_csv(url, encoding='windows-1251', skiprows=skiprows, skipfooter=skipfooter, delimiter=';', header=None, engine='python')


    columns_to_drop = [0, 2, 5, 6]
    df = df.drop(df.columns[columns_to_drop], axis=1)
    df.columns = ['full_date', 'description', 'dow_name']

    df['full_date'] = pd.to_datetime(df['full_date'], format='%d.%m.%Y').dt.strftime('%Y-%m-%d')

    return df


if __name__=='__main__':
    token = '******************' # Получил с сайта https://production-calendar.ru/manual
    current_year = datetime.date.today().year
    years = [current_year - 1, current_year, current_year + 1]

    combined_dfs = []

    for year in years:
        df = get_csv(year, token)
        combined_dfs.append(df)
    
    combined_df = pd.concat(combined_dfs, ignore_index=True)
    output = StringIO()
    combined_df.to_csv(output, index=False, sep=',', quoting=csv.QUOTE_NONNUMERIC, encoding='UTF-8')
    print(output.getvalue())
