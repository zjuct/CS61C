#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    node* slow = head;
    node* fast = head;
    while(slow && fast){
        slow = slow->next;
        if(fast->next == NULL){
            return 0;
        }
        fast = fast->next->next;
        if(slow == fast){
            return 1;
        }
    }
    return 0;
}