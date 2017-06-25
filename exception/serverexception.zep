
namespace ArangoDB\Exception;

/**
 * ServerException class
 *
 * Thrown by client when there is error on client side
 *
 * @package ArangoDB/Exception
 * @class ServerException
 * @author Lucas S. Vieira
 */
class ServerException extends \Exception {

  /**
   * TODO add class name
   **/
  public function __toString(){
    return this->getMessage();
  }
}
