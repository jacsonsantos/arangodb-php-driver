namespace Arango\Connection;

use Arango\Http\Api;
use Arango\Http\Response;
use Arango\Connection\Connection;
use Arango\Exception\ClientException;

/**
 * An endpoint contains the server location the client connects to
 * the following endpoint types are currently supported:
 *
 * tcp://host:port for tcp connections <br>
 * unix://socket for UNIX sockets (provided the server supports this) <br>
 * ssl://host:port for SSL connections (provided the server supports this) <br>
 *
 * Note: SSL support is added in Arango server 1.1 <br>
 *
 * @package Arango/Connection
 * @class Options
 * @author Lucas S. Vieira
 */
class Endpoint {

  /**
   * TCP endpoint type
   */
  const TYPE_TCP = "tcp";

  /**
   * SSL endpoint type
   */
  const TYPE_SSL = "ssl";

  /**
   * UNIX socket endpoint type
   */
  const TYPE_UNIX = "unix";

  /**
   * Regexp for TCP endpoints
   */
  const REGEXP_TCP = "/^tcp:\/\/(.+?):(\d+)\/?$/";

  /**
  * Regexp for SSL endpoints
  */
  const REGEXP_SSL = "/^ssl:\/\/(.+?):(\d+)\/?$/";

  /**
   * Regexp for UNIX socket endpoints
   */
  const REGEXP_UNIX = "/^unix:\/\/(.+)$/";

  /**
   * Endpoint index
   */
  const ENTRY_ENDPOINT = "endpoint";

  /**
   * Databases index
   */
  const ENTRY_DATABASES = "databases";

  /**
   * Current endpoint value
   */
  private value;

  /**
   * Create a new endpoint
   *
   * @throws \Arango\Exception\ClientException
   * @param string value - endpoint specification
   */
  public function __construct(string value){
    if(!self::isValid(value)){
      throw new ClientException(sprintf("Invalid endpoint specification '%s'", value));
    }

    let this->value = value;
  }

  /**
   * Endpoint representation
   *
   * @return string
   */
  public function __toString(){
    return this->value;
  }

  /**
   * Return the type of an endpoint
   *
   * @param string value - endpoint specification
   * @return string | null
   */
  public static function getType(string value) -> string | null {
    if(preg_match(self::REGEXP_TCP, value)){
      return self::TYPE_TCP;
    }

    if(preg_match(self::REGEXP_SSL, value)){
      return self::TYPE_SSL;
    }

    if(preg_match(self::REGEXP_UNIX, value)){
      return self::TYPE_UNIX;
    }

    return null;
  }

  /**
   * Return the host of an endpoint
   *
   * @param string value - endpoint specification
   * @return string | null
   */
  public static function getHost(string value) -> string | null {
    var matches;

    if(preg_match(self::REGEXP_TCP, value, matches)){
      return matches[1];
    }

    if(preg_match(self::REGEXP_SSL, value, matches)){
      return matches[1];
    }

    return null;
  }

  /**
   * Check if an endpoint specification is valid
   *
   * @param string value - endpoint specification
   * @return string
   */
  public static function isValid(string value) -> boolean {
    var type;

    let type = self::getType(value);

    return in_array(type, [
      self::TYPE_TCP, self::TYPE_SSL, self::TYPE_UNIX
    ]);
  }

  /**
   * List endpoints
   *
   * This will list the endpoints that are configured on the server
   *
   * @throws \Arango\Exception\ClientException
   * @link https://docs.Arango.com/devel/Manual/Administration/Configuration/Endpoint.html
   * @param Connection connection - the connection to be used
   * @return array
   */
  public function listEndpoints(<Connection> connection) -> array {
    var response;

    let response = connection->get(Api::ENDPOINT);
    return response->toArray();
  }
}
