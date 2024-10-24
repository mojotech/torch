defmodule Torch.I18n.Backend do
  @moduledoc """
  Provides messages for different parts of the package. Can
  also be overridden to include custom translations.
  """

  use Gettext, backend: Torch.Gettext

  def message("Contains"), do: dgettext("default", "Contains")
  def message("Equals"), do: dgettext("default", "Equals")
  def message("Choose one"), do: dgettext("default", "Choose one")
  def message("Before"), do: dgettext("default", "Before")
  def message("After"), do: dgettext("default", "After")
  def message("Greater Than"), do: dgettext("default", "Greater Than")
  def message("Greater Than Or Equal"), do: dgettext("default", "Greater Than Or Equal")
  def message("Less Than"), do: dgettext("default", "Less Than")
  def message("start"), do: dgettext("default", "start")
  def message("end"), do: dgettext("default", "end")
  def message("Select Date"), do: dgettext("default", "Select Date")
  def message("Select Start Date"), do: dgettext("default", "Select Start Date")
  def message("Select End Date"), do: dgettext("default", "Select End Date")
  def message("< Prev"), do: dgettext("default", "< Prev")
  def message("Next >"), do: dgettext("default", "Next >")
  def message("Any"), do: dgettext("default", "Any")
  def message("True"), do: dgettext("default", "True")
  def message("False"), do: dgettext("default", "False")
  def message("Cancel"), do: dgettext("default", "Cancel")
  def message("Submit"), do: dgettext("default", "Submit")
  def message("Back"), do: dgettext("default", "Back")
  def message("Edit"), do: dgettext("default", "Edit")
  def message("Show"), do: dgettext("default", "Show")
  def message("Delete"), do: dgettext("default", "Delete")
  def message("Are you sure?"), do: dgettext("default", "Are you sure?")
end
