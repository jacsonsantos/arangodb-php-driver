
namespace Arango\Policies;

use Arango\Exception\ClientException;

/**
 * Validate an supplied update policy value
 *
 * @package Arango/Policies
 * @class UpdatePolicy
 * @author Lucas S. Vieira
 */
class UpdatePolicy implements Policy {

  /* Last update will win in case of conflicting versions*/
  const LAST = "last";

  /* An error will be returned in case of conflicting versions */
  const ERROR = "error";

  /**
   * Validate a supplied policy value
   *
   * @throws \Arango\Exception\ClientException
   * @param string value
   * @return void
   */
  public static function validate(string value) -> void {
    if(value != self::LAST && value != self::ERROR){
      throw new ClientException("Invalid policy");
    }
  }
}
