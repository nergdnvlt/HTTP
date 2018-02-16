require './test/test_helper'

require './lib/diagnose'

class DiagnosticTest < MiniTest::Test
  def setup
    @request = ['GET / HTTP/1.1',
                'Host: 127.0.0.1:9292',
                'Connection: keep-alive',
                'Cache-Control: no-cache',
                'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2)',
                'Postman-Token: 4331415e-edea-a89a-9b02-21bccb082332',
                'Accept: */*',
                'Accept-Encoding: gzip, deflate, br',
                'Accept-Language: en-US,en;q=0.9']
  end

  def test_verb_method
    assert_equal 'GET', Diagnose.verb(@request)
  end

  def test_methods_inside_verb
    assert_equal 'GET', @request[0].split[0]
  end

  def test_path_method
    assert_equal '/', Diagnose.path(@request)
  end

  def test_protocol_method
    result = Diagnose.protocol(@request)
    assert_equal 'HTTP/1.1', result
  end

  def test_host_method
    result = Diagnose.host(@request)
    assert_equal '127.0.0.1:9292', result
  end

  def test_port_method
    result = Diagnose.port(@request)
    assert_equal '9292', result
  end

  def test_accept_method
    result = Diagnose.accept(@request)
    assert_equal '*/*', result
  end

  def test_diagnostic
    expected = "Verb: GET
    <br>Path: /
    <br>Protocol: HTTP/1.1
    <br>Host: 127.0.0.1:9292
    <br>Port: 9292
    <br>Origin: 127.0.0.1:9292
    <br>Accept: */*"
    result = Diagnose.diagnostic(@request)
    assert_equal expected, result
  end

  def test_accept_is_nil
    request = ['GET / HTTP/1.1',
               'Host: 127.0.0.1:9292',
               'Connection: keep-alive',
               'Cache-Control: no-cache',
               'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X)',
               'Postman-Token: 4331415e-edea-a89a-9b02-21bccb082332']
    expected = "Verb: GET
    <br>Path: /
    <br>Protocol: HTTP/1.1
    <br>Host: 127.0.0.1:9292
    <br>Port: 9292
    <br>Origin: 127.0.0.1:9292
    <br>Accept: "
    result = Diagnose.diagnostic(request)
    assert_equal expected, result
  end

  def test_for_shutdown
    expected = 'Total Requests: 10'

    assert_equal expected, Diagnose.shutdown(10)
  end

  def test_path_for_datetime
    expected = Time.now.strftime('%H:%M%p on %A, %B %d, %Y')
    result = Diagnose.time

    assert_equal expected, result
  end

  def test_for_dictionary_known
    result = Diagnose.dictionary('hi')
    assert_equal 'HI is a known word', result
  end

  def test_for_dictionary_unknown
    result = Diagnose.dictionary('afse')
    assert_equal 'AFSE is not a known word', result
  end
end
