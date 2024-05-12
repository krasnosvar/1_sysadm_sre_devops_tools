from flask import Flask, request
# import simplejson as json


app = Flask(__name__)

@app.route('/')
def main():
    # print(request.headers)
    x_forwarded_f = request.headers.get('x-forwarded-for')
    x_real_ip = request.headers.get('x-real-ip')
    multiline_return_var = f'''x-forwarded-for: {x_forwarded_f}
x-real-ip: {x_real_ip}

request.headers:
{request.headers}'''

    return multiline_return_var

if __name__ == '__main__':
    app.run()
