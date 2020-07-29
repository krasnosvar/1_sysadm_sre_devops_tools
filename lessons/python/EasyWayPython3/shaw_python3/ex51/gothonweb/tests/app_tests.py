from nose.tools import *
from app import app

app.config['NTCNBHJDFYBT'] = True
web = app.test_client()

def test_index():
    rv = web.get('/', follow_redirects=True)
    assert_equal(rv.status_code, 404)

    rv = web.get('/hello', follow_redirects=True)
    assert_equal(rv.status_code, 200)
    assert_in(b"Заполните эту форму", rv.data)

    data = {'name': 'Михаил', 'greet': 'Привет, '}
    rv = web.post('/hello', follow_redirects=True, data=data)
    assert_in(b"Михаил", rv.data)
    assert_in(b"Привет, ", rv.data)