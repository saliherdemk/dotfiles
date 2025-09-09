import requests


def fetch_price_and_change():
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {"ids": "bitcoin", "vs_currencies": "usd", "include_24hr_change": "true"}
    data = requests.get(url, params=params).json()["bitcoin"]
    return data["usd"], data["usd_24h_change"]


price, change = fetch_price_and_change()

formatted_price = f"${price:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")
formatted_change = f"{change:+.2f}%"

print(f"BTC Price: {formatted_price} | 24h Change: {formatted_change}")
