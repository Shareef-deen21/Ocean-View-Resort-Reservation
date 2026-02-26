package com.oceanview.command;

/**
 * COMMAND PATTERN — every DB operation is an encapsulated command
 */
public interface ReservationCommand {
    void execute() throws Exception;
    String getDescription();
}
