### Architecture and todos:

From a modeling perspective: 

 - A `Command` is the response of the system to an `Event`.
  - User attempts to withdraw a sum of money from his bank account. `Event`: `WithdrawAmountRequested` -> `Command`: `WithdrawAmount`      
 - A `Command` refers to a domain object(`Aggregate`) that it may apply to.
  - `WithdrawAmmount` refers to an `Account`. `Aggregate`: `Account`
 - A `command` can have effects based on `preconditions`. The `command` may thus affect an `aggregate` and generate an `event`
  - The user has enough money in his account and the amount he requested is withdrawn. Event: `AmountWithdrawn`
  - The user doesn't have enough money and the amount he requested is not withdrawn. Event: `WithdrawalDenied`

Aggregates can be kept as the latest state.

The command may produce no effects



User clicks submit to a CreateFoo form, this is an event, the command is to CreateFoo.

Commands are sent to a kafka topic and they refer to a domain object, here the CreateFoo command refers to the Foo that will be created.

Commands are stored and processed via a kafka topic: let <app-name>-command-topic and a command processor.

The command processor


