import random
import datetime
import pyodbc
from datetime import datetime as dt


# Please set your parameters here
servername = r'GEPHAZ\GEPHAZ'
number_of_records = 27

# connection to server
con_str = f"Driver=ODBC Driver 17 for SQL Server;Server={servername};Database=AdventureWorks2022;Trusted_Connection=yes;"
con = pyodbc.connect(con_str, autocommit=True)
curs = con.cursor()


# function to generate data
def generate_header(customerid_s, customerid_o, salespersonid, adressid, cardid):

    # set fix parameters
    record = []
    online_choose = random.randint(0, 1)
    today = dt.now()
    no_of_details = random.randint(1, 8)
    fk_choose = random.randint(0, 40)

    # set data
    salesorderid = '0'
    revisionnumber = 0
    orderdate = today - datetime.timedelta(days=7)
    duedate = today - datetime.timedelta(days=3)
    shipdate = today
    status = 5
    territoryid = random.randint(1, 10)
    billtoaddress = adressid[fk_choose][0]
    shiptoaddress = billtoaddress
    creditcardid = cardid[fk_choose][0]
    creditcardappcode = f'{random.randint(100000, 900000)}Vi{random.randint(100000, 900000)}'
    subtotal = round(random.uniform(1000.00, 100000.00), 4)
    taxamnt = round(subtotal / 6, 4)
    freight = round(subtotal / 20, 4)
    comment = None

    if online_choose == 0:
        onlineorderflag = 0
        purchaseordernumber = f'PO{random.randint(100000, 600000)}{random.randint(10000, 700000)}'
        salespersonid = salespersonid[random.randint(0, 16)][0]
        shipmethod = 5
        currencyrateid = None


        customerid = customerid_s[fk_choose][0]
        accountnumber = f'10-40{random.randint(40, 70)}-0{customerid}'
    else:
        onlineorderflag = 1
        purchaseordernumber = None
        salespersonid = None
        shipmethod = 1
        currencyrateid = 4
        customerid = customerid_o[fk_choose][0]
        accountnumber = f'10-40{random.randint(40, 70)}-0{customerid}'

    record.extend([no_of_details, salesorderid, revisionnumber, orderdate.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3],
                   duedate.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3], shipdate.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3], status,
                   onlineorderflag, purchaseordernumber, accountnumber, customerid, salespersonid, territoryid,
                   billtoaddress, shiptoaddress, shipmethod, creditcardid, creditcardappcode, currencyrateid,
                   subtotal, taxamnt, freight, comment])
    return record


# function to generate data
def generate_details(id, trcknum, prod_offer):
    d_record = []

    salesorder = id
    crriertrackingnum = trcknum
    orderqty = random.randint(1, 6)
    pf_choose = random.randint(1, 50)
    product = prod_offer[pf_choose][1]
    specialloffer = prod_offer[pf_choose][0]
    unitprice = round(random.uniform(10.00, 900.00), 3)
    discount = 0.00

    d_record.extend([salesorder, crriertrackingnum, orderqty, product, specialloffer, unitprice, discount])
    return d_record


# function to refresh the db
def upload():
    global number_of_records

    # get customerid
    q_text_s = 'SELECT TOP (100) [CustomerID] FROM [Sales].[Customer] WHERE StoreID is not null ' \
               'and PersonID is null ORDER BY NEWID()'
    result_s = curs.execute(q_text_s).fetchall()
    q_text_o = 'SELECT TOP (100) [CustomerID] FROM [Sales].[Customer] WHERE PersonID is not null ' \
               'and StoreID is null ORDER BY NEWID()'
    result_o = curs.execute(q_text_o).fetchall()

    # get salespersonid
    q_text3 = "SELECT BusinessEntityID FROM Sales.SalesPerson"
    result3 = curs.execute(q_text3).fetchall()

    # get adressid
    q_text4 = "SELECT TOP 100 AddressID FROM Person.[Address] ORDER BY NEWID()"
    result4 = curs.execute(q_text4).fetchall()

    # get creditcard
    q_text5 = "SELECT TOP 100 CreditCardID FROM Sales.PersonCreditCard ORDER BY NEWID()"
    result5 = curs.execute(q_text5).fetchall()

    # get product/offer
    q_text6 = "SELECT TOP 100 [SpecialOfferID], [ProductID] FROM [Sales].[SpecialOfferProduct] ORDER BY NEWID()"
    result6 = curs.execute(q_text6).fetchall()

    for i in range(number_of_records):

        header = generate_header(result_s, result_o, result3, result4, result5)

        # check new records in CMD (debug)
        print(f"*********** Header {i +1} *************")
        print(header)
        print("")

        # insert
        q_text6 = "INSERT INTO [Sales].[SalesOrderHeader] ([RevisionNumber], [OrderDate], [DueDate], [ShipDate]," \
                  " [Status], [OnlineOrderFlag], [PurchaseOrderNumber], [AccountNumber], [CustomerID]," \
                  " [SalesPersonID], [TerritoryID], [BillToAddressID], [ShipToAddressID], [ShipMethodID]," \
                  " [CreditCardID], [CreditCardApprovalCode], [CurrencyRateID], [SubTotal], [TaxAmt], [Freight]," \
                  " [Comment]) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        curs.execute(q_text6, header[2], header[3], header[4], header[5], header[6], header[7], header[8], header[9],
                     header[10], header[11], header[12], header[13], header[14], header[15], header[16], header[17],
                     header[18], header[19], header[20], header[21], header[22])

        # get new record id to populate
        q_text1 = "SELECT MAX(SalesOrderID) FROM Sales.SalesOrderHeader"
        result1 = curs.execute(q_text1).fetchone()
        salesorderid = int(result1[0])

        for k in range(header[0]):
            trnnum = f"{random.randint(1, 9)}{random.choices(['F', 'T', 'V', 'H', 'E', 'J'])[0]}{random.randint(1, 9)}"\
                    f"{random.choices(['F', 'T', 'V', 'H', 'E', 'J'])[0]}-{random.randint(1, 9)}{random.randint(1, 9)}"\
                    f"{random.choices(['F', 'T', 'V', 'H', 'E', 'J'])[0]}" \
                    f"{random.choices(['F', 'T', 'V', 'H', 'E', 'J'])[0]}-{random.randint(1, 9)}" \
                    f"{random.choices(['F', 'T', 'V', 'H', 'E', 'J'])[0]}"
            details = generate_details(salesorderid, trnnum, result6)

            # check new records in CMD (debug)
            print(f"----------------- Details {k + 1} -----------------")
            print(details)
            print("")

            # insert
            q_text6 = "INSERT INTO [Sales].[SalesOrderDetail] ([SalesOrderID], [CarrierTrackingNumber], [OrderQty]," \
                      " [ProductID], [SpecialOfferID], [UnitPrice], [UnitPriceDiscount])  VALUES (?, ?, ?, ?, ?, ?, ?)"
            curs.execute(q_text6, details[0], details[1], details[2], details[3], details[4], details[5], details[6])


upload()
